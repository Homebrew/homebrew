require 'formula'

class OpusTools < Formula
  homepage 'http://www.opus-codec.org'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.3.tar.gz'
  sha1 '82f9f2cbabfbfac9bea4354a043a0fcaf2e03a47'
=======
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.4.tar.gz'
  sha1 'b4030cd65afa57340b5ae25fe3467808ca1454cf'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'http://downloads.xiph.org/releases/opus/opus-tools-0.1.6.tar.gz'
  sha1 '305eb5eed76ddc0b5f12605a8b549638afc15885'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  head 'https://git.xiph.org/opus-tools.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'opus'
  depends_on 'libogg'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
