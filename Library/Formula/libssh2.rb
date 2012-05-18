require 'formula'

class Libssh2 < Formula
  url 'http://www.libssh2.org/download/libssh2-1.4.1.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 'b94106e046af37fdc0734e487842fe66'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
