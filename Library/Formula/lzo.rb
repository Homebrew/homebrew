require "formula"

class Lzo < Formula
  desc "Real-time data compression library"
  homepage "http://www.oberhumer.com/opensource/lzo/"
  url "http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
  sha256 "f294a7ced313063c057c504257f437c8335c41bfeed23531ee4e6a2b87bcb34c"

  bottle do
    cellar :any
    revision 1
    sha1 "fc54913e0f6dc60b981dd6526995ef0679efaabc" => :yosemite
    sha1 "d732cb14e6182d58a04362f80a27142dccf88677" => :mavericks
    sha1 "eba9019e3538d22f2c6a268c8736f34db468fa29" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
