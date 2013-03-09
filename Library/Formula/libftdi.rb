require 'formula'

class Libftdi < Formula
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.0.tar.bz2"
  sha1 '5be76cfd7cd36c5291054638f7caf4137303386f'

  depends_on 'boost'
  depends_on 'libusb-compat'

  def install
    mkdir 'libftdi-build' do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
