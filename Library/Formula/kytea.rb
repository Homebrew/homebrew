require 'formula'

class Kytea < Formula
  url 'http://www.phontron.com/kytea/download/kytea-0.4.2.tar.gz'
  homepage 'http://www.phontron.com/kytea/'
  md5 '2104e3e9a3587826bf04887d5f7fd03e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
