require "formula"

class Libechonest < Formula
  homepage "https://projects.kde.org/projects/playground/libs/libechonest"
  url "http://files.lfranchi.com/libechonest-2.3.0.tar.bz2"
  sha1 "cf1b279c96f15c87c36fdeb23b569a60cdfb01db"

  bottle do
    cellar :any
    sha1 "78c787069afab61d3b364886cbb9a777c2d1558c" => :mavericks
    sha1 "14e726d2267171af68e4548662284d443072a4d9" => :mountain_lion
    sha1 "d983fbabb1c3e5a68111dd325c41dc9eb3999c42" => :lion
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "qjson"

  conflicts_with "doxygen", :because => "cmake fails to configure build."

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
