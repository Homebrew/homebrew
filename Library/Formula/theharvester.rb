require 'formula'

class Theharvester < Formula
  homepage 'https://code.google.com/p/theharvester/'
  url 'https://theharvester.googlecode.com/files/theHarvester-2.2a.tar.gz'
  sha1 'e02661ed6dd8d9d48d476ccee99878e15f67842a'

  depends_on :python

  def install
    libexec.install Dir['*']
    (libexec/'theHarvester.py').chmod 0755
    bin.install_symlink libexec/'theHarvester.py' => 'theharvester'
  end

  test do
    output = `#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1`.strip
    assert_match(/misty@brew\.sh/, output)
  end
end
