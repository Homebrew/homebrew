require 'formula'

class Geowebcache < Formula
  version '1.2.6'
  url "http://sourceforge.net/projects/geowebcache/files/geowebcache/#{version}/geowebcache-#{version}-war.zip/download"
  homepage 'http://geowebcache.org/'
  md5 '2ddf026b49aecb9eac1f9e67975ee6b4'
end

class Geoserver < Formula
  version '2.1-RC5'
  url "http://downloads.sourceforge.net/geoserver/geoserver-#{version}-bin.zip"
  homepage 'http://geoserver.org'
  md5 '3ef93c9bf069e7de619be9bc2f412514'

  def options
    [
      ['--with-geowebcache', "Install an additional Geo-Web-Cache (#{Geowebcache.homepage})"]
    ]
  end

  def caveats
    s = "You can start/stop the geoserver via 'geoserver_startup.sh'/'geoserver_shutdown.sh'."
    s << "\nConsider using '--with-geowebcache' to install the optional cache." unless ARGV.include? '--with-geowebcache'
    s
  end

  def install
    rm_f Dir['bin/*.bat']
    prefix.install Dir['*.txt']
    unless File.exists? var + name + 'data_dir'
      (var + name).install Dir['data_dir']
    else
      ohai "Directory #{var + name + 'data_dir'} already exists!", 'Skipping install of data_dir!'
      rm_rf Dir['data_dir']
    end
    libexec.install Dir['*']
    Dir[libexec + 'bin/*'].each do |file|
      (bin + ('geoserver_' + File.basename(file))).write <<-EOS.undent
        #!/bin/sh
        export GEOSERVER_DATA_DIR=#{var + name}/data_dir
        export GEOSERVER_HOME=#{libexec}
        . #{file}
      EOS
    end
    Geowebcache.new.brew { (libexec + 'webapps' + name).install Dir['*'] } if ARGV.include? '--with-geowebcache'
  end
end
