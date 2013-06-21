require 'formula'

class Nginx < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.4.1.tar.gz'
  sha1 '9c72838973572323535dae10f4e412d671b27a7e'

  devel do
    url 'http://nginx.org/download/nginx-1.5.1.tar.gz'
    sha1 'bd5a5e7dba39a4aa166918112367589f165ce5bc'
  end

  head 'http://hg.nginx.org/nginx/', :using => :hg

  env :userpaths

  # Inbuilt compile-time flags
  option 'with-debug', 'Compile with support for debug log'
  option 'with-addition', 'Compile with Addition module'
  option 'with-degredation', 'Compile with http degredation module'
  option 'with-perl', 'Compile with Embedded Perl module'
  option 'with-flv', 'Compile with flv module'
  option 'with-geoip', 'Compile with geoip module'
  option 'with-google=perftools', 'Compile with Google Performance tools module'
  option 'with-gunzip', 'Compile with support for gunzip module'
  option 'with-gzip-static', 'Compile with gzip static module'
  option 'with-image-filter', 'Compile with Image Filter module'
  option 'with-mp4', 'Compile with mp4 module'
  option 'with-random-index', 'Compile with random index module'
  option 'with-realip', 'Compile with RealIP support'
  option 'with-secure-link', 'Compile with secure link module'
  option 'with-spdy', 'Compile with support for SPDY module'
  option 'with-ssl', 'Compile with support for SSL module'
  option 'with-stub', 'Compile with stub status module'
  option 'with-sub', 'Compile with Substitution module'
  option 'with-webdav', 'Compile with support for WebDAV module'
  option 'with-xslt', 'Compile with XSLT module'
  # Additional
  option 'with-passenger', 'Compile with support for Phusion Passenger module'

  depends_on 'pcre'
  # SPDY needs openssl >= 1.0.1 for NPN; see:
  # https://tools.ietf.org/agenda/82/slides/tls-3.pdf
  # http://www.openssl.org/news/changelog.html
  depends_on 'openssl' if build.with? 'spdy'

  skip_clean 'logs'

  # Changes default port to 8080
  def patches
    DATA
  end

  def passenger_config_args
    passenger_root = `passenger-config --root`.chomp

    if File.directory?(passenger_root)
      return "--add-module=#{passenger_root}/ext/nginx"
    end

    puts "Unable to install nginx with passenger support. The passenger"
    puts "gem must be installed and passenger-config must be in your path"
    puts "in order to continue."
    exit
  end

  def install
    cc_opt = "-I#{HOMEBREW_PREFIX}/include"
    ld_opt = "-L#{HOMEBREW_PREFIX}/lib"

    if build.with? 'spdy'
      openssl_path = Formula.factory("openssl").opt_prefix
      cc_opt += " -I#{openssl_path}/include"
      ld_opt += " -L#{openssl_path}/lib"
    end

    args = ["--prefix=#{prefix}",
            "--with-pcre",
            "--with-ipv6",
            "--sbin-path=#{bin}/nginx",
            "--with-cc-opt=#{cc_opt}",
            "--with-ld-opt=#{ld_opt}",
            "--conf-path=#{etc}/nginx/nginx.conf",
            "--pid-path=#{var}/run/nginx.pid",
            "--lock-path=#{var}/run/nginx.lock",
            "--http-client-body-temp-path=#{var}/run/nginx/client_body_temp",
            "--http-proxy-temp-path=#{var}/run/nginx/proxy_temp",
            "--http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp",
            "--http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp",
            "--http-scgi-temp-path=#{var}/run/nginx/scgi_temp",
            "--http-log-path=#{var}/log/nginx"
          ]

    #inbuilt compile-time flags
    args << "--with-debug" if build.include? 'with-debug'
    args << "--with-http_addition_module" if build.include? 'with-addition'
    args << "--with-http_degradation_module" if build.include? 'with-degredation'
    args << "--with-http_perl_module" if build.include? 'with-perl'
    args << "--with-http_flv_module" if build.include? 'with-flv'
    args << "--with-http_geoip_module" if build.include? 'with-geoip'
    args << "--with-google_perftools_module" if build.include? 'with-google-pertools'
    args << "--with-http_gunzip_module" if build.include? 'with-gunzip'
    args << "--with-http_gzip_static_module" if build.include? 'with-gzip-static'
    args << "--with-http_image_filter_module" if build.include? 'with-image-filter'
    args << "--with-http_mp4_module" if build.include? 'with-mp4'
    args << "--with-http_random_index_module" if build.include? 'with-random-index'
    args << "--with-http_realip_module" if build.include? 'with-realip'
    args << "--with-http_secure_link_module" if build.include? 'with-secure-link'
    args << "--with-http_spdy_module" if build.include? 'with-spdy'
    args << "--with-http_ssl_module" if build.include? 'with-ssl'
    args << "--with-http_stub_status_module" if build.include? 'with-stub-status'
    args << "--with-http_sub_module" if build.include? 'with-sub'
    args << "--with-http_dav_module" if build.include? 'with-webdav'
    args << "--with-http_xslt_module" if build.include? 'with-xslt'
    # Additional
    args << passenger_config_args if build.include? 'with-passenger'

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end
    system "make"
    system "make install"
    man8.install "objs/nginx.8"
    (var/'run/nginx').mkpath

    # nginx’s docroot is #{prefix}/html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    prefix.cd do
      dst = HOMEBREW_PREFIX/"var/www"
      if not dst.exist?
        dst.dirname.mkpath
        mv "html", dst
      else
        rm_rf "html"
        dst.mkpath
      end
      Pathname.new("#{prefix}/html").make_relative_symlink(dst)
    end

    # for most of this formula’s life the binary has been placed in sbin
    # and Homebrew used to suggest the user copy the plist for nginx to their
    # ~/Library/LaunchAgents directory. So we need to have a symlink there
    # for such cases
    if (HOMEBREW_CELLAR/'nginx').subdirs.any?{|d| (d/:sbin).directory? }
      sbin.mkpath
      sbin.cd do
        (sbin/'nginx').make_relative_symlink(bin/'nginx')
      end
    end
  end

  def caveats; <<-EOS.undent
    Docroot is: #{HOMEBREW_PREFIX}/var/www

    The default port has been set to 8080 so that nginx can run without sudo.

    If you want to host pages on your local machine to the wider network you
    can change the port to 80 in: #{HOMEBREW_PREFIX}/etc/nginx/nginx.conf

    You will then need to run nginx as root: `sudo nginx`.
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/nginx</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end

__END__
--- a/conf/nginx.conf
+++ b/conf/nginx.conf
@@ -33,7 +33,7 @@
     #gzip  on;

     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;

         #charset koi8-r;
