require "socket"

class Opentsdb < Formula
  desc "Scalable, distributed Time Series Database."
  homepage "http://opentsdb.net/"
  url "https://github.com/OpenTSDB/opentsdb/releases/download/v2.2.0/opentsdb-2.2.0.tar.gz"
  sha256 "5689d4d83ee21f1ce5892d064d6738bfa9fdef99f106f45d5c38eefb9476dfb5"

  option "without-lzo", "Don't use LZO Compression"

  if build.without? "lzo"
    depends_on "hbase"
  else
    depends_on "hbase" => "with-lzo"
  end
  depends_on :java => "1.6+"
  depends_on "gnuplot" => :optional

  def install
    # submitted to upstream https://github.com/OpenTSDB/opentsdb/pull/711
    # mkdir_p is called from in a subdir of build so needs an extra ../ and there is no rule to create $(classes) and
    # everything builds without specifying them as dependencies of the jar.
    inreplace "Makefile.in" do |s|
      s.sub!(/(\$\(jar\): manifest \.javac-stamp) \$\(classes\)/, '\1')
      s.sub!(/(echo " \$\(mkdir_p\) '\$\$dstdir'"; )/, '\1../')
    end

    mkdir "build" do
      system "../configure",
             "--disable-silent-rules",
             "--prefix=#{prefix}",
             "--mandir=#{man}",
             "--sysconfdir=#{etc}",
             "--localstatedir=#{var}/opentsdb"
      system "make"
      system "make", "install-exec-am"
      system "make", "install-data-am"
    end

    env = Language::Java.java_home_env.merge(:HBASE_HOME => Formula["hbase"].opt_libexec, :COMPRESSION => (build.with?("lzo") ? "LZO" : "NONE"))
    (bin/"create_table.sh").write_env_script opt_pkgshare/"tools/create_table.sh", env
  end

  def post_install
    (var/"cache/opentsdb").mkpath
    etc.install Dir["#{opt_pkgshare}/etc/opentsdb"]

    system "#{Formula["hbase"].opt_libexec}/bin/start-hbase.sh"

    system "#{bin}/create_table.sh"

    system "#{Formula["hbase"].opt_libexec}/bin/stop-hbase.sh"
  end

  plist_options :manual => "tsdb tsd --config=#{HOMEBREW_PREFIX}/etc/opentsdb/opentsdb.conf "\
                           "--staticroot=#{HOMEBREW_PREFIX}/opt/opentsdb/share/opentsdb/static/ "\
                           "--cachedir=#{HOMEBREW_PREFIX}/var/cache/opentsdb --port=4242 "\
                           "--zkquorum=localhost:2181 --zkbasedir=/hbase --auto-metric"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>OtherJobEnabled</key>
        <string>#{Formula["hbase"].plist_name}</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/tsdb</string>
        <string>tsd</string>
        <string>--config=#{etc}/opentsdb/opentsdb.conf</string>
        <string>--staticroot=#{opt_pkgshare}/static/</string>
        <string>--cachedir=#{var}/cache/opentsdb</string>
        <string>--port=4242</string>
        <string>--zkquorum=localhost:2181</string>
        <string>--zkbasedir=/hbase</string>
        <string>--auto-metric</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/opentsdb/opentsdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/opentsdb/opentsdb.err</string>
    </dict>
    </plist>
    EOS
  end

  test do

    cp_r (Formula["hbase"].libexec/"conf"), testpath
    inreplace (testpath/"conf/hbase-site.xml") do |s|
      s.gsub! /(hbase.rootdir.*)\n.*/, "\\1\n<value>file://#{testpath}/hbase</value>"
      s.gsub! /(hbase.zookeeper.property.dataDir.*)\n.*/, "\\1\n<value>#{testpath}/zookeeper</value>"
    end

    ENV["HBASE_LOG_DIR"]  = (testpath/"logs")
    ENV["HBASE_CONF_DIR"] = (testpath/"conf")
    ENV["HBASE_PID_DIR"]  = (testpath/"pid")

    system "#{Formula["hbase"].opt_bin}/start-hbase.sh"
    sleep 2

    pid = Process.spawn "#{bin}/tsdb tsd --config=#{HOMEBREW_PREFIX}/etc/opentsdb/opentsdb.conf --staticroot=#{HOMEBREW_PREFIX}/opt/opentsdb/share/opentsdb/static/ --cachedir=#{HOMEBREW_PREFIX}/var/cache/opentsdb --port=4242 --zkquorum=localhost:2181 --zkbasedir=/hbase --auto-metric"

    Socket.tcp("localhost", 4242) do |s|
      s.puts "put homebrew.install.test 1356998400 42.5 host=webserver01 cpu=0"
    end

    system "#{bin}/tsdb", "query", "1356998000", "1356999000", "sum", "homebrew.install.test", "host=webserver01", "cpu=0"

    Process.kill(9, pid)

    system "#{Formula["hbase"].opt_bin}/stop-hbase.sh"
  end
end
