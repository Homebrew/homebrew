class Libiodbc < Formula
  homepage "http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/"
  url "http://sourceforge.net/projects/iodbc/files/iodbc/3.52.10/libiodbc-3.52.10.tar.gz/download"
  sha256 "1568b42b4e97f36110af661d39bfea7d94ac4ff020014574b16a7199f068e11f"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    system "sh",  "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/iodbc-config", "--version"
  end
end
