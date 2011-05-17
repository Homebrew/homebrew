require 'formula'

class Amap < Formula
  url 'http://www.thc.org/releases/amap-5.4.tar.gz'
  homepage 'http://www.thc.org/thc-amap/'
  md5 '2617c13b0738455c0e61c6e980b8decc'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make install"
  end
end
