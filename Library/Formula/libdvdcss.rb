class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.0/libdvdcss-1.4.0.tar.bz2"
  sha256 "2089375984800df29a4817b37f3123c1706723342d6dab4d0a8b75c25c2c845a"

  bottle do
    cellar :any
    sha256 "b46bbb4c0171ba189a991e8b6c6248e8f5d2b84ccb9ba10a7e36659281383514" => :el_capitan
    sha256 "e4bdd8b17ba4090c3d37462e52c8fd4081ecdb1ae0ed2dd489e883b71081cc1f" => :yosemite
    sha256 "e00c47db17a7cd58a4f74422c25821f32e120a3b7c17b136939e7b33d4a38b0d" => :mavericks
    sha256 "c56de86974076eb11a8c55e73a6c1b2e2cff61a6fee7936250be56ef686adc9f" => :mountain_lion
  end

  head do
    url "git://git.videolan.org/libdvdcss"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
