require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.3.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  sha1 '2ecd23c38d74e5f04757dc528ec30858006fb6a7'

  if ARGV.include? '--with-php'
    depends_on 'php'
  end

  def install
    # fixes compile error: missing symbols being optimized out using llvm.
    if ENV.compiler == :llvm then
      inreplace 'src/geom/Makefile.in', 'CFLAGS = @CFLAGS@', 'CFLAGS = @CFLAGS@ -O1'
      inreplace 'src/geom/Makefile.in', 'CXXFLAGS = @CXXFLAGS@', 'CXXFLAGS = @CXXFLAGS@ -O1'
    end

    # Allow building the PHP extension.
    args = []

    if ARGV.include? '--with-php'
      args << "--enable-php"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", *args
    system "make install"
  end
end
