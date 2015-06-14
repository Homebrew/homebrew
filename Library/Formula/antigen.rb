class Antigen < Formula
  desc "A plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.tar.gz"
  sha256 "6d4bd7b5d7bc3e36a23ac8feb93073b06e1e09b9100eb898f66c2e8c3f4d7847"
  head "https://github.com/zsh-users/antigen/archive"

  def install
    bin.install "antigen.zsh"
  end

  test do
    (testpath/".zshrc").write "source antigen.zsh"
    system "/bin/zsh", "--login", "-i", "-c", "antigen help"
  end

  def caveats; <<-EOS.undent
    To use antigen, add the following line to your ~/.zshrc:
    source antigen.zsh
    EOS
  end
end
