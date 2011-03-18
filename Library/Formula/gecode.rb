require 'formula'

class Gecode <Formula
  url 'http://www.gecode.org/download/gecode-3.5.0.tar.gz'
  homepage 'http://www.gecode.org/index.html'
  md5 'bb920bb708b6ef9c4e9f5fa47681a659'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", 
    "--with-architectures=i386,x86_64", "--disable-qt",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
