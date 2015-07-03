class IsoCodes < Formula
  desc "ISO language, territory, currency, script codes, and their translations"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.59.tar.xz"
  sha256 "63d5ef035a96223f1fc8f36b711082f806e1666852dfc4149eeca8fd435d76ed"

  head "git://git.debian.org/git/iso-codes/iso-codes.git"

  bottle do
    cellar :any
    sha256 "4e4a5a8c8e9c823915d2548379dd9063aa9271045e8263dd4ff95c1b3f79c0e6" => :yosemite
    sha256 "c8072dcdb49816cb0fab8261e8051718cb6cdab381dbe1713665773956e0bf4b" => :mavericks
    sha256 "c26eb05aa26a4b5b66d83ccdc7c8f8558766e14890d390993868e7896b23a1e2" => :mountain_lion
  end

  depends_on "gettext" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
