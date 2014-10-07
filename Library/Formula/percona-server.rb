require 'formula'

class PerconaServer < Formula
  homepage 'http://www.percona.com'
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.6/LATEST/source/tarball/percona-server-5.6.20-68.0.tar.gz'
  version '5.6.20-68.0'
  sha1 '0a550a783500fe0386bfac450d2d2090c8e76ddc'

  bottle do
    sha1 "b8e9a7397a2aafceeb8743ff80902f860d7e4e3a" => :mavericks
    sha1 "098cd5e0030eda037c3d186ad56bf1ab4ffa507e" => :mountain_lion
    sha1 "81bb3111f982ecd7340d55abfafbcd2b50891637" => :lion
  end

  depends_on 'cmake' => :build
  depends_on 'pidof' unless MacOS.version >= :mountain_lion

  option :universal
  option 'with-tests', 'Build with unit tests'
  option 'with-embedded', 'Build the embedded server'
  option 'with-memcached', 'Build with InnoDB Memcached plugin'
  option 'enable-local-infile', 'Build with local infile loading support'
  option 'without-server', 'Build only the mysql client'

  conflicts_with 'mysql-connector-c',
    :because => 'both install `mysql_config`'

  conflicts_with 'mariadb', 'mysql', 'mysql-cluster',
    :because => "percona, mariadb, and mysql install the same binaries."
  conflicts_with 'mysql-connector-c',
    :because => 'both install MySQL client libraries'

  fails_with :llvm do
    build 2334
    cause "https://github.com/Homebrew/homebrew/issues/issue/144"
  end

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/msyql to be
  # shared with the mysql and mariadb formulae.
  def datadir
    @datadir ||= (var/'percona').directory? ? var/'percona' : var/'mysql'
  end

  def pour_bottle?
    datadir == var/"mysql"
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DMYSQL_DATADIR=#{datadir}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DSYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=Homebrew
      -DWITH_EDITLINE=system
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
    ]

    # PAM plugin is Linux-only at the moment
    args.concat %W[
      -DWITHOUT_AUTH_PAM=1
      -DWITHOUT_AUTH_PAM_COMPAT=1
      -DWITHOUT_DIALOG=1
    ]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? 'tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? 'embedded'

    # Build with InnoDB Memcached plugin
    args << "-DWITH_INNODB_MEMCACHED=ON" if build.with? 'memcached'

    # Make universal for binding to universal applications
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'
    
    # Only build the client
    args << "-DWITHOUT_SERVER=1" if build.include? 'without-server'

    system "cmake", *args
    system "make"
    system "make install"

    unless build.include? 'without-server'
      # Don't create databases inside of the prefix!
      # See: https://github.com/Homebrew/homebrew/issues/4975
      rm_rf prefix+'data'

      # Link the setup script into bin
      bin.install_symlink prefix/"scripts/mysql_install_db"

      # Fix up the control script and link into bin
      inreplace "#{prefix}/support-files/mysql.server" do |s|
        s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
        # pidof can be replaced with pgrep from proctools on Mountain Lion
        s.gsub!(/pidof/, 'pgrep') if MacOS.version >= :mountain_lion
      end

      bin.install_symlink prefix/"support-files/mysql.server"
    end

    # Move mysqlaccess to libexec
    mv "#{bin}/mysqlaccess", libexec
    mv "#{bin}/mysqlaccess.conf", libexec
  end

  def post_install
    unless build.include? 'without-server'
      # Make sure that data directory exists
      datadir.mkpath
      unless File.exist? "#{datadir}/mysql/user.frm"
        ENV['TMPDIR'] = nil
        system "#{bin}/mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
          "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
      end
    end
  end

  def caveats; <<-EOS.undent
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot
    EOS
  end unless build.include? 'without-server'

  plist_options :manual => 'mysql.server start'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{opt_bin}/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end unless build.include? 'without-server'
end
