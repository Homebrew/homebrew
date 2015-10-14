class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "http://www.git-town.com"
  url "https://github.com/Originate/git-town/archive/v0.8.0.tar.gz"
  sha256 "7a8037719feaa82966ef2633235a4a107c2302db3bdd147be98555616fff12cd"

  bottle do
    cellar :any
    sha256 "330ad68d6262f44e7e8b32176335ce96beb96bd05526e3ca11f7a726d904f62c" => :yosemite
    sha256 "64c9fdae40b5a88cc42a5b2d9d6b6d8934a8d5da5f6810294c7968c562e69aab" => :mavericks
    sha256 "09560a9c1c363f097b8a06d2ff86f60bcdbfe592e848fb61cf0a89d1bcd2c727" => :mountain_lion
  end

  def install
    libexec.install Dir["src/*"]
    bin.write_exec_script Dir["#{libexec}/git-*"]
    man1.install Dir["man/man1/*"]
  end

  def caveats; <<-EOS.undent
    To install the Fish shell autocompletions run:
      `git town install-fish-autocompletion`
    in your terminal.
  EOS
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
