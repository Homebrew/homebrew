require "language/javascript"

class Iojs < Formula
  include Language::JS

  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v2.0.0/iojs-v2.0.0.tar.xz"
  sha256 "4f61318361b752382f13cad631548677f7ec2ba21b3dc4c3cca2369a7e253baa"

  bottle do
    sha256 "e535a806b9090b4ba229b4a724fd00a44f9df26f9614eb5cac6739376a9fd0b9" => :yosemite
    sha256 "e8a671371dfc9adaeea54b4410929ca4bafe9f62bc6b036f0f08f3c278409036" => :mavericks
    sha256 "023b19b7fa74a044a358157abdcab628c272860ecd9f12be5ac6aa3cce41da01" => :mountain_lion
  end

  conflicts_with "node", :because => "node and iojs both install a binary/link named node"

  option "with-debug", "Build with debugger hooks"
  option "with-icu4c", "Build with Intl (icu4c) support"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :optional
  depends_on :python => :build

  resource "npm" do
    url Language::JS::NPM_URL
    sha256 Language::JS::NPM_SHA256
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage npm_buildpath = buildpath/"npm_install"
      install_npm npm_buildpath

      if build.with? "completion"
        install_npm_bash_completion npm_buildpath
      end
    end
  end

  def post_install
    return if build.without? "npm"

    npm_post_install libexec
  end

  def caveats
    s = ""

    s += npm_caveats

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/iojs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      assert_equal which("node"), opt_bin/"node"
      npm_test_install
    end
  end
end

