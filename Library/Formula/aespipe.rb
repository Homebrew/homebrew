require 'formula'

class Aespipe < Formula
  url 'http://loop-aes.sourceforge.net/aespipe/aespipe-v2.4c.tar.bz2'
  homepage 'http://loop-aes.sourceforge.net/'
  sha1 '198cc0bc1168a7a150de4b7308be096c903b0d90'
  version '2.4'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
