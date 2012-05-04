require 'formula'

class Cogl < Formula
  homepage 'http://wiki.clutter-project.org/wiki/Cogl'
  url 'http://source.clutter-project.org/sources/cogl/1.10/cogl-1.10.2.tar.bz2'
  sha256 'ce4705693e98c064d5493913b2ffe23a49a9c83b644b2277d882b960369bc545'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
