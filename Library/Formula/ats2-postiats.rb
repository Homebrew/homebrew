class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.1/ATS2-Postiats-0.2.1.tgz"
  sha256 "0a0d3a7e762a7a7ae77e5d3e27ccdc43766d19316579bfa2015a9f7977e86f7b"

  bottle do
    cellar :any
    sha256 "610c16028ad304d1ceff668caabe1747b0dcdf0e30c53999c7180f71b35fecae" => :yosemite
    sha256 "ab945998ef2c119a37ca558a0c74c23d447a00598f3c2c3c139648addb3f2631" => :mavericks
    sha256 "88088dfb23656af89907bf82d280910b6eda7a49420e8e21246f223422614f96" => :mountain_lion
  end

  depends_on "gmp"

  fails_with :clang do
    cause "Trying to compile this with Clang is failure-galore."
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"

    # Disable GC support for patsopt
    # https://github.com/githwxi/ATS-Postiats/issues/76
    system "make", "GCFLAG=-D_ATS_NGC", "all"
    system "make", "install"
  end

  test do
    (testpath/"hello.dats").write <<-EOS.undent
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
