class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "http://ftpmirror.gnu.org/parallel/parallel-20151222.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20151222.tar.bz2"
  sha256 "ae927c260fb86c24e0a2717d3b214996a9547d1a2be4ff3bfebd9f23b5bd9f0d"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06b56794970ba3adff3f772635bf58b43c88bd99c0bf12f13d1dd6886f2b3995" => :el_capitan
    sha256 "84b83c7502f968e092478e8832184a5700271586b78e47e6c331c042593a961e" => :yosemite
    sha256 "ad60b296427bf2cef4153e2ad6e693c1d2edffbffd242fdc633b01451a8e275e" => :mavericks
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
