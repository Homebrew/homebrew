require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.0.2.tar.gz'
  sha1 '471de56191114f4fb4d557ec366d6978c2c1312d'

  depends_on :fortran

  def install
    system "./configure", "FCCPP=#{ENV.cc} -E -C -ansi",
           "CC=#{ENV.cc}", "CFLAGS=-pipe",
           "--prefix=#{prefix}", "--enable-shared"
    system "make"
    system "make install"
  end
end
