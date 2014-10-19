require 'formula'

class LibsvgCairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz'
  sha1 'c7bf131b59e8c00a80ce07c6f2f90f25a7c61f81'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "8e6ca63907708f900f23e1da966a05731ff966eb" => :yosemite
    sha1 "0ee61ff2dc93ca0eb2536c931bd187bb7d07a7ff" => :mavericks
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsvg'
  depends_on 'libpng'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
