class Gwenhywfar < Formula
  homepage "http://www.aqbanking.de/"
  url "http://www2.aquamaniac.de/sites/download/download.php?package=01&release=77&file=01&dummy=gwenhywfar-4.13.0.tar.gz"
  sha1 "c4f37eb7fed069f3478e06a9311193a98cc9ddbf"
  head "http://devel.aqbanking.de/svn/gwenhywfar/trunk"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "openssl"
  depends_on "libgcrypt"
  depends_on "gtk+" => :optional
  depends_on "qt" => :optional

  option "without-cocoa", "Build without cocoa support"
  option "with-check", "Run build-time check"

  def install
    guis = []
    guis << "gtk2" if build.with? "gtk+"
    guis << "qt4" if build.with? "qt"
    guis << "cocoa" if build.with? "cocoa"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-guis=#{guis.join(" ")}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
end
