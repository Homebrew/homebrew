class Slrn < Formula
  homepage "http://slrn.sourceforge.net/"
  url "http://jedsoft.org/releases/slrn/slrn-1.0.2.tar.bz2"
  sha1 "2a3a305fd887183625b65d3a1316351b5ac3c259"

  head "git://git.jedsoft.org/git/slrn.git"

  bottle do
    sha1 "e340d7c49f46ddb2ce83a1fdaf3bf51e6c6e4cc0" => :yosemite
    sha1 "15707ce07fb09b9220ec56955f16aa9ef8e14760" => :mavericks
    sha1 "8f308966cc962b23a0f340ad524febbbc94cfd34" => :mountain_lion
  end

  depends_on "s-lang"
  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"slrn", "--show-config"
  end
end
