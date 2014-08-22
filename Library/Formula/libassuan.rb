require "formula"

class Libassuan < Formula
  homepage "http://www.gnupg.org/related_software/libassuan/index.en.html"
  url "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.1.2.tar.bz2"
  sha1 "7aed69734ba64b63004107cada671b5861d332a4"

  bottle do
    cellar :any
    sha1 "f732a521a63d06685b485c3cf99e912e9227bca1" => :mavericks
    sha1 "602a54e5ea291bdc46e9999f1afb2deba8d88e49" => :mountain_lion
    sha1 "c354db0ed33861930e670344bed27abe8709f978" => :lion
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
