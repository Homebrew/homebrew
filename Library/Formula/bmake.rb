class Bmake < Formula
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20150410.tar.gz"
  sha256 "72727f5ddce4448a0136a1e2c536f7627440e3e482700b43c666f96737b2bfce"

  bottle do
    sha1 "bfb80b95386a6e9c439167573d58a9623650708e" => :yosemite
    sha1 "9ae644344202f0e42eaac253e38b95d16c23433d" => :mavericks
    sha1 "e91b8e0f374eeaf85ef53bf4d92df3cf1d646a97" => :mountain_lion
  end

  def install
    # The first, an oversight upstream; the second, don't pre-roff cat pages.
    inreplace "bmake.1", ".Dt MAKE", ".Dt BMAKE"
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = [ "--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install" ]

    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
