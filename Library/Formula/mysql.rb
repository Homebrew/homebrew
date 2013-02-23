require 'formula'

class Mysql < Formula
  homepage 'http://dev.mysql.com/doc/refman/5.5/en/'
  url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.10.tar.gz/from/http://cdn.mysql.com/'
  version '5.6.10'
  sha1 'f37979eafc241a0ebeac9548cb3f4113074271b7'

  bottle do
    sha1 'e07b9a207364b6e020fc96f49116b58d33d0eb78' => :mountain_lion
    sha1 'b9b38e2ed705a3fcd79bb549f32e49b455f31917' => :lion
    sha1 '30978684ee72c4dfb0b20263331b0c93972b3092' => :snow_leopard
  end

  depends_on 'cmake' => :build
  depends_on 'pidof' unless MacOS.version >= :mountain_lion

  option :universal
  option 'with-tests', 'Build with unit tests'
  option 'with-embedded', 'Build the embedded server'
  option 'with-libedit', 'Compile with editline wrapper instead of readline'
  option 'with-archive-storage-engine', 'Compile with the ARCHIVE storage engine enabled'
  option 'with-blackhole-storage-engine', 'Compile with the BLACKHOLE storage engine enabled'
  option 'enable-local-infile', 'Build with local infile loading support'
  option 'enable-memcached', 'Enable innodb-memcached support'
  option 'enable-debug', 'Build with debug support'

  conflicts_with 'mariadb',
    :because => "mysql and mariadb install the same binaries."

  conflicts_with 'percona-server',
    :because => "mysql and percona-server install the same binaries."

<<<<<<< HEAD
  conflicts_with 'mariadb',
    :because => "mysql and mariadb install the same binaries."
  conflicts_with 'percona-server',
    :because => "mysql and percona-server install the same binaries."
=======
  conflicts_with 'mysql-cluster',
    :because => "mysql and mysql-cluster install the same binaries."

  env :std if build.universal?
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  fails_with :llvm do
    build 2326
    cause "https://github.com/mxcl/homebrew/issues/issue/144"
  end

<<<<<<< HEAD
  skip_clean :all # So "INSTALL PLUGIN" can work.

<<<<<<< HEAD
  def options
    [
      ['--with-tests', "Build with unit tests."],
      ['--with-embedded', "Build the embedded server."],
      ['--with-libedit', "Compile with EditLine wrapper instead of readline"],
      ['--with-archive-storage-engine', "Compile with the ARCHIVE storage engine enabled"],
      ['--with-blackhole-storage-engine', "Compile with the BLACKHOLE storage engine enabled"],
      ['--universal', "Make mysql a universal binary"],
      ['--enable-local-infile', "Build with local infile loading support"]
    ]
  end

  # Remove optimization flags from `mysql_config --cflags`
  # This facilitates easy compilation of gems using a brewed mysql
  # Also fix compilation with Xcode and no CLT: http://bugs.mysql.com/bug.php?id=66001
  def patches; DATA; end

=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    # Make sure the var/mysql directory exists
    (var+"mysql").mkpath

    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{var}/mysql",
            "-DINSTALL_MANDIR=#{man}",
            "-DINSTALL_DOCDIR=#{doc}",
            "-DINSTALL_INFODIR=#{info}",
            # CMake prepends prefix, so use share.basename
            "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/#{name}",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.include? 'with-tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.include? 'with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless build.include? 'with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.include? 'with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.include? 'with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if build.universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'

    # Build with memcached support
    args << "-DWITH_INNODB_MEMCACHED=1" if build.include? 'enable-memcached'

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.include? 'enable-debug'

    system "cmake", *args
    system "make"
    system "make install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Link the setup script into bin
    ln_s prefix+'scripts/mysql_install_db', bin+'mysql_install_db'
    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, 'pgrep') if MacOS.version >= :mountain_lion
    end
    ln_s "#{prefix}/support-files/mysql.server", bin

    # Move mysqlaccess to libexec
    mv "#{bin}/mysqlaccess", libexec
    mv "#{bin}/mysqlaccess.conf", libexec
  end

  def caveats; <<-EOS.undent
    Set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=#{var}/mysql --tmpdir=/tmp

    To set up base tables in another folder, or use a different user to run
    mysqld, view the help for mysql_install_db:
        mysql_install_db --help

    and view the MySQL documentation:
      * http://dev.mysql.com/doc/refman/5.5/en/mysql-install-db.html
      * http://dev.mysql.com/doc/refman/5.5/en/default-privileges.html

    To run as, for instance, user "mysql", you may need to `sudo`:
        sudo mysql_install_db ...options...

    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot
    EOS
  end

  plist_options :manual => "mysql.server start"

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
      <string>#{opt_prefix}/bin/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    (opt_prefix+'mysql-test').cd do
      system './mysql-test-run.pl', 'status'
    end
  end
end
<<<<<<< HEAD


__END__
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index 9296075..70c18db 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -137,7 +137,9 @@ for remove in DDBUG_OFF DSAFE_MUTEX DUNIV_MUST_NOT_INLINE DFORCE_INIT_OF_VARS \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]' \
+              aes Os
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
diff --git a/cmake/libutils.cmake b/cmake/libutils.cmake
index 89a9de9..677c68d 100644
--- a/cmake/libutils.cmake
+++ b/cmake/libutils.cmake
@@ -183,7 +183,7 @@ MACRO(MERGE_STATIC_LIBS TARGET OUTPUT_NAME LIBS_TO_MERGE)
       # binaries properly)
       ADD_CUSTOM_COMMAND(TARGET ${TARGET} POST_BUILD
         COMMAND rm ${TARGET_LOCATION}
-        COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION} 
+        COMMAND libtool -static -o ${TARGET_LOCATION} 
         ${STATIC_LIBS}
       )  
     ELSE()
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
