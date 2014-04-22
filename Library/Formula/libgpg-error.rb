require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.13.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.13.tar.bz2'
  sha1 '50fbff11446a7b0decbf65a6e6b0eda17b5139fb'

  bottle do
    cellar :any
    sha1 "462425fc9fcfb5ffc9be39dcfc4bbf41ae85a89e" => :mavericks
    sha1 "bad8593df9630e361413d6df5a9927718e3a0aa4" => :mountain_lion
    sha1 "dc93a01632457b6c36b738894a4ac94bfa585730" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
