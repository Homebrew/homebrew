# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  homepage "http://www.erlang.org"

  stable do
    # Download tarball from GitHub; it is served faster than the official tarball.
    url "https://github.com/erlang/otp/archive/OTP-17.4.1.tar.gz"
    sha256 "3ff545f086c541d1d5fefc9777ed5ddc93f3a20bf30d93f38399fba417ccf58e"
  end

  head "https://github.com/erlang/otp.git"

  bottle do
    sha1 "6194f633e00ffb805b514ace20ba4d12f51a4e33" => :yosemite
    sha1 "a6a667c269d067717465de2cc7a3e0cf0901202f" => :mavericks
    sha1 "cbea1cc87f07cc262cde7ae06ebe55963db8baec" => :mountain_lion
  end

  resource "man" do
    url "http://www.erlang.org/download/otp_doc_man_17.4.tar.gz"
    sha256 "6c1cdb8e9d367c7b6dc6b20706de9fd0a0f0b7dffd66532663b2a24ed7679a58"
  end

  resource "html" do
    url "http://www.erlang.org/download/otp_doc_html_17.4.tar.gz"
    sha256 "dd42b0104418de18e2247608a337bcd3bb24c59bbc36294deb5fae73ab6c90d6"
  end

  option "without-hipe", "Disable building hipe; fails on various OS X systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "unixodbc" if MacOS.version >= :mavericks
  depends_on "fop" => :optional # enables building PDF docs
  depends_on "wxmac" => :recommended # for GUI apps like observer

  depends_on "libressl" => :optional
  depends_on "openssl" unless build.with? "libressl"

  fails_with :llvm

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --enable-shared-zlib
      --enable-smp-support
    ]

    if build.with? "libressl"
      args << "--with-ssl=#{Formula["libressl"].opt_prefix}"
    else
      paths << "--with-ssl=#{Formula["openssl"].opt_prefix}"
    end

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"

    if MacOS.version >= :snow_leopard && MacOS::CLT.installed?
      args << "--with-dynamic-trace=dtrace"
    end

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on OS X
      # http://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # http://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    system "./configure", *args
    system "make"
    ENV.j1 # Install is not thread-safe; can try to create folder twice and fail
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
