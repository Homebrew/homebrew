class ChinadnsC < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.3.0/chinadns-1.3.0.tar.gz"
  sha1 "0877eed8bb385ca72cede3b3fca35f5d5e40e999"

  bottle do
    cellar :any
    sha1 "0dbcdbbc318f54e3b5a9c848bb02c53cf170ddd4" => :yosemite
    sha1 "e069b91a3284bb1305542dc8be0205a5804499bb" => :mavericks
    sha1 "aa418b88cf95d41948bcecaaf6a007c6b32d0551" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "chinadns", "-h"
  end
end
