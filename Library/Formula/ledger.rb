class Ledger < Formula
  homepage "http://ledger-cli.org"
  url "https://github.com/ledger/ledger/archive/v3.1.tar.gz"
  sha1 "549aa375d4802e9dd4fd153c45ab64d8ede94afc"
  head "https://github.com/ledger/ledger.git"

  bottle do
    revision 2
    sha1 "661106efe731cb8934269f0e9141b6c846b65710" => :yosemite
    sha1 "80b7a33291be43598d5084da49d8783ee7780679" => :mavericks
    sha1 "087576750c2d1df2367a7bac2617e54dbedc2866" => :mountain_lion
  end

  resource "utfcpp" do
    url "http://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
    sha1 "638910adb69e4336f5a69c338abeeea88e9211ca"
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python", "Build without python support"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"

  stable do
    # don't explicitly link a python framework
    # https://github.com/ledger/ledger/pull/415
    patch do
      url "https://github.com/ledger/ledger/commit/5f08e27.diff"
      sha256 "064b0e64d211224455511cd7b82736bb26e444c3af3b64936bec1501ed14c547"
    end
  end

  needs :cxx11

  def install
    ENV.cxx11

    (buildpath/"lib/utfcpp").install resource("utfcpp") unless build.head?
    resource("utfcpp").stage { include.install Dir["source/*"] }

    flavor = (build.with? "debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]

    args << "--python" if build.with? "python"

    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"

    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args
    (share+"ledger/examples").install Dir["test/input/*.dat"]
    (share+"ledger").install "contrib"
    (share+"ledger").install "python/demo.py" if build.with? "python"
    (share/"emacs/site-lisp/ledger").install Dir["lisp/*.el", "lisp/*.elc"]
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", share/"ledger/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $?.exitstatus

    if build.with? "python"
      system "python", "#{share}/ledger/demo.py"
    end
  end
end
