require "formula"

class Monetdb < Formula
  homepage "https://www.monetdb.org/"
  url "https://dev.monetdb.org/downloads/sources/Oct2014/MonetDB-11.19.7.zip"
  sha1 "af542dc85a8474eb4bcf32565eccae3ea5d22768"

  bottle do
    sha1 "e5802401b81d035fe81a9a708dd647128a0a4302" => :yosemite
    sha1 "ecefa004cd231e9ad1eef530ae9194f5e3db8c13" => :mavericks
    sha1 "484c94edf77b0acb72aa0e0cb7a8017c149be95c" => :mountain_lion
  end

  head do
    url "http://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "libtool" => :build
    depends_on "gettext" => :build
  end
  
  option "with-java"
  option "with-rintegration"

  depends_on "pkg-config" => :build
  depends_on :ant => :build
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit.
  depends_on "openssl"
  depends_on "libatomic_ops" => :recommended

  depends_on "unixodbc" => :optional # Build the ODBC driver
  depends_on "geos" => :optional # Build the GEOM module
  depends_on "gsl" => :optional
  depends_on "cfitsio" => :optional
  depends_on "homebrew/php/libsphinxclient" => :optional

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-debug=no",
            "--enable-assert=no",
            "--enable-optimize=yes",
            "--enable-testing=no",
            "--with-readline=#{Formula["readline"].opt_prefix}", # Use the correct readline
            "--without-rubygem"]

    args << "--with-java=no" if build.without? "java"
    args << "--disable-rintegration" if build.without? "rintegration"

    system "./configure", *args
    system "make install"
  end
end
