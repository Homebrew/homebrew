class Memo < Formula
  url "http://www.getmemo.org/memo-1.5.tar.gz"
  homepage "http://www.getmemo.org"
  sha1 "3e047b09e91d695f1767d1dd6d179732c07a5759"

  def install
    system "make"
    bin.install "memo"
    man1.install "memo.1"
  end

  test do
    ENV["MEMO_PATH"] = testpath/"memos"
    system "#{bin}/memo", "-a",  "Lorem ipsum dolor sit amet."
  end
end
