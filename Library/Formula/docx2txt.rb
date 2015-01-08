class Docx2txt < Formula
  homepage "http://docx2txt.sourceforge.net/"
  url "https://github.com/Killeroid/docx2txt/archive/v1.4.tar.gz"
  head "https://github.com/Killeroid/docx2txt.git"
  sha1 "c4be6ce70e0bb3216542b95bf6574c2ee40f660a"

  def install
    inreplace "README", "docx2txt.pl", "docx2txt"

    inreplace "docx2txt.pl", "our \$systemConfigDir = \"/etc\"", "our \$systemConfigDir = \"#{etc}\""

    bin.install "docx2txt.pl" => "docx2txt"
    etc.install "docx2txt.config"
    doc.install "AUTHORS", "COPYING", "README"
    man1.install "docx2txt.1"
  end

  test do
    system bin/"docx2txt", "-h"
  end

end