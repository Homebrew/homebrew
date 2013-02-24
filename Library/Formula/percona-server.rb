require 'formula'

class PerconaServer < Formula
  homepage 'http://www.percona.com'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.25a-27.1/source/Percona-Server-5.5.25a-rel27.1.tar.gz'
  version '5.5.25-27.1'
  sha1 'f3388960311b159e46efd305ecdeb806fe2c7fdc'
=======
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.27-28.0/source/Percona-Server-5.5.27-rel28.0.tar.gz'
  version '5.5.27-28.0'
  sha1 '5e6bb13ac6cec9fdf88251939e40e10c8bdef4a9'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.29-29.4/source/Percona-Server-5.5.29-rel29.4.tar.gz'
  version '5.5.29-29.4'
  sha1 '0c02296414739a29e8a3c81ff7fab68a45d5b8a2'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  depends_on 'cmake' => :build
  depends_on 'readline'
  depends_on 'pidof'

<<<<<<< HEAD
=======
  option :universal
  option 'with-tests', 'Build with unit tests'
  option 'with-embedded', 'Build the embedded server'
  option 'with-libedit', 'Compile with editline wrapper instead of readline'
  option 'enable-local-infile', 'Build with local infile loading support'

>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
  conflicts_with 'mysql',
    :because => "percona-server and mysql install the same binaries."

  conflicts_with 'mariadb',
    :because => "percona-server and mariadb install the same binaries."

  conflicts_with 'mysql-cluster',
    :because => "percona-server and mysql-cluster install the same binaries."

  env :std if build.universal?

  fails_with :llvm do
    build 2334
    cause "https://github.com/mxcl/homebrew/issues/issue/144"
  end

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/msyql to be
  # shared with the mysql and mariadb formulae.
  def destination
    @destination ||= (var/'percona').directory? ? 'percona' : 'mysql'
  end

  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    # Make sure that data directory exists
    (var/destination).mkpath

    args = [
      ".",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DMYSQL_DATADIR=#{var}/#{destination}",
      "-DINSTALL_MANDIR=#{man}",
      "-DINSTALL_DOCDIR=#{doc}",
      "-DINSTALL_INFODIR=#{info}",
      # CMake prepends prefix, so use share.basename
      "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql",
      "-DWITH_SSL=yes",
      "-DDEFAULT_CHARSET=utf8",
      "-DDEFAULT_COLLATION=utf8_general_ci",
      "-DSYSCONFDIR=#{etc}",
      "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
      # PAM plugin is Linux-only at the moment
      "-DWITHOUT_AUTH_PAM=1",
      "-DWITHOUT_AUTH_PAM_COMPAT=1",
      "-DWITHOUT_DIALOG=1"
    ]

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

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if build.universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? 'enable-local-infile'

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
    end

    ln_s "#{prefix}/support-files/mysql.server", bin
  end

  def caveats; <<-EOS.undent
    Set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix percona-server)" --datadir=#{var}/#{destination} --tmpdir=/tmp

    To set up base tables in another folder, or use a different user to run
    mysqld, view the help for mysqld_install_db:
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
end
<<<<<<< HEAD


__END__
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index 9296075..a600de2 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -137,7 +137,8 @@ for remove in DDBUG_OFF DSAFE_MUTEX DUNIV_MUST_NOT_INLINE DFORCE_INIT_OF_VARS \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
diff --git a/scripts/mysqld_safe.sh b/scripts/mysqld_safe.sh
index 37e0e35..38ad6c8 100644
--- a/scripts/mysqld_safe.sh
+++ b/scripts/mysqld_safe.sh
@@ -558,7 +558,7 @@ else
 fi
 
 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
=======
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
