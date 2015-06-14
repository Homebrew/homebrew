require "formula"

class Cgvg < Formula
  desc "Command-line source browsing tool"
  homepage "http://www.uzix.org/cgvg.html"
  url "http://www.uzix.org/cgvg/cgvg-1.6.3.tar.gz"
  sha1 "d5a108e470b6e7bdf7863c540aaf0efc9ddf1335"

  bottle do
    cellar :any
    sha1 "a3fcc3b1176529bc6e8c748b7ab0da5a4619d217" => :mavericks
    sha1 "7239ed81b63640aa43661a3d2c8aa86668125fb8" => :mountain_lion
    sha1 "06a91bea44a04501f593a43b02437bc4969a34a3" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
