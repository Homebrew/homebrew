class Node < Formula
  desc "Platform built on the V8 JavaScript runtime to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v5.1.0/node-v5.1.0.tar.gz"
  sha256 "25b2d3b7dd57fe47a483539fea240a3c6bbbdab4d89a45a812134cf1380ecb94"
  head "https://github.com/nodejs/node.git"

  bottle do
    sha256 "0f9518b4847974b8b67cb195c4e0b3d3797325658eb1beb5d3390a0141821bb9" => :el_capitan
    sha256 "86fa3b3c73ca32d262dac36328d8d67d14d10e6caf32c73f9bda06603677c488" => :yosemite
    sha256 "35f7b653e07ad00eefa0b3b869d3f47cb6979062f95008f0b84977f5ea984c2a" => :mavericks
  end

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "with-full-icu", "Build with full-icu (all locales) instead of small-icu (English only)"

  deprecated_option "enable-debug" => "with-debug"
  deprecated_option "with-icu4c" => "with-full-icu"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :llvm
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  resource "icu4c" do
    url "https://ssl.icu-project.org/files/icu4c/56.1/icu4c-56_1-src.tgz"
    mirror "https://ftp.mirrorservice.org/sites/download.qt-project.org/development_releases/prebuilt/icu/src/icu4c-56_1-src.tgz"
    version "56.1"
    sha256 "3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816"
  end

  def install
    args = %W[--prefix=#{prefix}]
    args << "--debug" if build.with? "debug"
    args << "--shared-openssl" if build.with? "openssl"
    if build.with? "full-icu"
      args << "--with-intl=full-icu"
    else
      args << "--with-intl=small-icu"
    end

    resource("icu4c").stage buildpath/"deps/icu"

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      if build.with? "completion"
        bash_completion.install \
          "#{lib}/node_modules/npm/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = lib/"node_modules"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    ["man1", "man3", "man5", "man7"].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.}*"]
      ln_sf Dir[lib/"node_modules/npm/man/#{man}/npm*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    if build.without? "full-icu"
      s += <<-EOS.undent
        Please note by default only English locale support is provided. If you need
        full locale support you should:
          `brew reinstall node --with-full-icu`
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat().format(1234.56))'").strip
    assert_equal "1,234.56", output

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      assert_equal which("node"), opt_bin/"node"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "bignum"
    end
  end
end
