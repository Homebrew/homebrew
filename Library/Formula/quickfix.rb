require 'formula'

class Quickfix < Formula
  homepage 'http://www.quickfixengine.org/index.html'
  url 'http://downloads.sourceforge.net/project/quickfix/quickfix/1.13.3/quickfix-1.13.3.tar.gz'
  sha1 '8a20894a9320206beaeee11c3967dced8b8d2fc0'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-java"
    system "make"
    ENV.j1 # failed otherwise
    system "make install"
  end
end
