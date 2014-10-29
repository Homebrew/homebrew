require 'formula'

class Ncmpcpp < Formula
  homepage 'http://ncmpcpp.rybczak.net/'
  url 'http://ncmpcpp.rybczak.net/stable/ncmpcpp-0.6.tar.bz2'
  sha1 '7bbd63c6f17aa8cdf1190b19e2dc893df188da1c'

  head do
    url 'git://repo.or.cz/ncmpcpp.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'taglib'
  depends_on 'libmpdclient'
  depends_on 'boost'
  depends_on 'readline'

  depends_on 'fftw' if build.include? "visualizer"

  option 'outputs', 'Compile with mpd outputs control'
  option 'visualizer', 'Compile with built-in visualizer'
  option 'clock', 'Compile with optional clock tab'

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append 'LDFLAGS', '-liconv'
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-taglib",
            "--with-curl",
            "--enable-unicode"]
    args << '--enable-outputs' if build.include? 'outputs'
    args << '--enable-visualizer' if build.include? 'visualizer'
    args << '--enable-clock' if build.include? 'clock'

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make install"
  end
end
