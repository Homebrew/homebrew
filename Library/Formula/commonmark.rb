class Commonmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.25.1.tar.gz"
  sha256 "70f31a9a91b42268e305c597f66f23f0b9c5f70a04f54c8de8b1754ce8df2043"

  bottle do
    cellar :any
    sha256 "729f196f3a6626fe62cff16635d0272eeed7e240b2f56bbf0cd93b3c6a86efdc" => :el_capitan
    sha256 "57a3a5d4f4b94bde7797103cc89fd2483a27c18d146aeb09568dfa7594d56a88" => :yosemite
    sha256 "250035b28f09bf54ed339aa995b69a1ee7bedf35b5f8bc7d0d48050da10d6f57" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    test_input = "*hello, world*\n"
    expected_output = "<p><em>hello, world</em></p>\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/cmark`
    assert_equal expected_output, test_output
  end
end
