require 'formula'

class MongoPhp < Formula
  url 'http://pecl.php.net/get/mongo-1.1.4.tgz'
  homepage 'http://pecl.php.net/package/mongo'
  md5 '22f1e25690589f6d80d5ed29e56644eb'  
  version '1.1.4'

  depends_on 'mongo'

  def install
    Dir.chdir "mongo-#{version}" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"

      prefix.install %w(modules/mongo.so)
    end
  end

  def caveats; <<-EOS.undent
    To finish installing MongoDB extension:
     * Add the following lines to #{etc}/php.ini:
        [mongo]
        extension="#{prefix}/mongo.so"
     * Restart your webserver
    EOS
  end
end