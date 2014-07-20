require "formula"

class Arping < Formula
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.14.tar.gz"
  sha1 "f691b19e1ad20b853202ee12eaf178232b466bb2"

  bottle do
    cellar :any
    sha1 "eabc0dbfda6ff745d722a9f9f7ff84db64381ccd" => :mavericks
    sha1 "38b7d22becfe47fd17ba3dd856fd17f6c90ffbc8" => :mountain_lion
    sha1 "877c2e5384864515e5861c8d3784d63440097433" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
