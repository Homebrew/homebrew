class Help2man < Formula
  homepage "https://www.gnu.org/software/help2man/"
  url "http://ftpmirror.gnu.org/help2man/help2man-1.46.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.46.5.tar.xz"
  sha256 "0ada23867183c5e779e06e6441801c5c74ff77af258e2f1bb5fce181fbc30ebf"

  bottle do
    cellar :any
    sha1 "6ba98c8f097531912e58863dee1247cb02f9c289" => :yosemite
    sha1 "747eadb45bf3bbcd2e2fd58dac062495768dd912" => :mavericks
    sha1 "134e606290c5c93f915c51fbe87a6ddaa352f1fd" => :mountain_lion
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/help2man #{bin}/help2man"
    assert_match(/"help2man #{version}"/, shell_output(cmd))
  end
end
