require 'formula'

class Discount < Formula
  desc "C implementation of Markdown"
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  url 'http://www.pell.portland.or.us/~orc/Code/discount/discount-2.1.8a.tar.bz2'
  sha256 'c01502f4eedba8163dcd30c613ba5ee238a068f75291be127856261727e03526'

  bottle do
    cellar :any
    sha1 "5671a9db7f30c9c5ace23a9eb85385a5f3c9aaee" => :yosemite
    sha1 "e867d81f742a6b27308c352888b5d3123ef2703b" => :mavericks
    sha1 "7453dfde1ff9b0157032ac123ae389b75867ddc8" => :mountain_lion
  end

  option "with-fenced-code", "Enable Pandoc-style fenced code blocks."

  conflicts_with 'markdown',
    :because => 'both discount and markdown ship a `markdown` executable.'

  def install
    args = %W[
        --prefix=#{prefix}
        --mandir=#{man}
        --with-dl=Both
        --enable-all-features
    ]
    args << "--with-fenced-code" if build.with? "fenced-code"
    system "./configure.sh", *args
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end
