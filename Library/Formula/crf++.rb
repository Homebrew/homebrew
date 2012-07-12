require 'formula'

class Crfxx < Formula
  url 'http://crfpp.googlecode.com/files/CRF++-0.57.tar.gz'
  homepage 'http://code.google.com/p/crfpp/'
  sha1 'bb80676edd8fee5835b967700c30884b50a7c766'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end
end
