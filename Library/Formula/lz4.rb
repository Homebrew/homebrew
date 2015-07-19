class Lz4 < Formula
  desc "Lossless compression algorithm"
  homepage "http://www.lz4.info/"
  url "https://github.com/Cyan4973/lz4/archive/r131.tar.gz"
  sha256 "9d4d00614d6b9dec3114b33d1224b6262b99ace24434c53487a0c8fd0b18cfed"
  version "r131"

  bottle do
    cellar :any
    sha256 "ddc009f6644dbfbe40f097164e4d32519dc425fbcbc4da2a730085c09e71cbb9" => :yosemite
    sha256 "32aca554261845d66f1a5b8a30c24100a65e7eeed3cb9936234c23a1942ffb34" => :mavericks
    sha256 "64b4d909025c00e2ae01d9dd1bedb56475d11ea30a3bae0c306e5aee4da0da09" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
