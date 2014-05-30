require 'formula'

class Libwpd < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libwpd/libwpd-0.10.0.tar.bz2'
  sha1 'bbcc6e528a69492fb2b4bbb9a56d385a29efc4c4'

  bottle do
    cellar :any
    sha1 "334b0073856d5a5dd70975f3f6500023a3e0df59" => :mavericks
    sha1 "ee03031fa7a4aa04972448d9b8d5107b270e564c" => :mountain_lion
    sha1 "c8f4dbf438c435c0a34c3a9984a2951bc2b418de" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on "glib"
  depends_on "librevenge"
  depends_on "libgsf"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make install"
  end
end
