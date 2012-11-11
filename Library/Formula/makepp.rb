require 'formula'

class Makepp < Formula
  homepage 'http://makepp.sourceforge.net/'
  url 'http://sourceforge.net/projects/makepp/files/2.0/makepp-2.0.tgz'
  sha1 '23995b1fc17255be6a42e5778f6027441dc44661'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    # Tests already exist in the build
  end
end
