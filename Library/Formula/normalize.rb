require 'formula'

class Normalize < Formula
  homepage 'http://normalize.nongnu.org/'
  url 'http://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz'
  sha1 '1509ca998703aacc15f6098df58650b3c83980c7'

  def install
    ENV.j1

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "normalize"
  end
end
