require "formula"

class Libbpg < Formula
  homepage "http://bellard.org/bpg/"
  url "http://bellard.org/bpg/libbpg-0.9.tar.gz"
  sha1 "d40209384adf517c773a7a28cec0d4759051bf2c"

  depends_on "libpng"
  depends_on "jpeg"

  def install
    # Following changes are necessary for compilation on OS X. These have been
    # reported to the author and can be removed once incorporated upstream.
    inreplace "libavutil/mem.c" do |s|
      s.gsub! "#include <malloc.h>", "#include <malloc/malloc.h>"
    end

    inreplace "Makefile" do |s|
      s.gsub! "--gc-sections", "-dead_strip"
      s.gsub! "LIBS:=-lrt -lm -lpthread", "LIBS:=-lm -lpthread"
    end

    bin.mkpath
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bpgenc", "#{HOMEBREW_PREFIX}/Library/Homebrew/test/fixtures/test.png"
  end
end
