class Nuxeo < Formula
  desc "Enterprise Content Management"
  homepage "https://nuxeo.github.io/"
  url "http://cdn.nuxeo.com/nuxeo-7.10/nuxeo-cap-7.10-tomcat.zip"
  version "7.10"
  sha256 "9e95fb4e3dd0fdac49395ae8b429c6cc7db3c621ecd4d0dff74ea706a2aba723"

  depends_on "poppler" => :recommended
  depends_on "pdftohtml" => :optional
  depends_on "imagemagick"
  depends_on "ghostscript"
  depends_on "ufraw"
  depends_on "libwpd"
  depends_on "exiftool"
  depends_on "ffmpeg" => :optional

  def install
    libexec.install Dir["#{buildpath}/*"]

    (bin/"nuxeoctl").write_env_script "#{libexec}/bin/nuxeoctl",
      {:NUXEO_HOME => "#{libexec}", :NUXEO_CONF => "#{etc}/nuxeo.conf"}


    inreplace "#{libexec}/bin/nuxeo.conf" do |s|
      s.gsub! /#nuxeo\.log\.dir.*/, "nuxeo.log.dir=#{var}/log/nuxeo"
      s.gsub! /#nuxeo\.data\.dir.*/, "nuxeo.data.dir=#{var}/lib/nuxeo/data"
      s.gsub! /#nuxeo\.tmp\.dir.*/, "nuxeo.tmp.dir=/tmp/nuxeo"
      s.gsub! /#nuxeo\.pid\.dir.*/, "nuxeo.pid.dir=#{var}/run/nuxeo"
    end
    etc.install "#{libexec}/bin/nuxeo.conf"
    (var/"log/nuxeo").mkpath
    (var/"lib/nuxeo/data").mkpath
    (var/"run/nuxeo").mkpath
    (var/"cache/nuxeo/packages").mkpath

    libexec.install_symlink var/"cache/nuxeo/packages"
  end

  def caveats; <<-EOS.undent
    You need to edit #{etc}/nuxeo.conf file to configure manually the server.
    Also, in case of upgrade, run 'nuxeoctl mp-upgrade' to ensure all
    downloaded addons are up to date.
    EOS
  end

  test do
    assert_equal "#{etc}/nuxeo.conf", shell_output("#{bin}/nuxeoctl config -q --get nuxeo.conf").strip
    assert_equal "#{libexec}", shell_output("#{bin}/nuxeoctl config -q --get nuxeo.home").strip
  end
end
