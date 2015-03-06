class Cyassl < Formula
  homepage "http://www.wolfssl.com/yaSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.4.0.tar.gz"
  sha256 "e23b7939c04bf18efa353ff9abfeaba3bcf454e47c9ced45e2aadab6660245f0"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha1 "47a068ee29646ef26b3f7e2a62268f62ed73dbec" => :yosemite
    sha1 "57f47edc303e4f7f07d893a0724c67e068ca4883" => :mavericks
    sha1 "c5de09829f89696a73a8f3818bbf413eae99e5ac" => :mountain_lion
  end

  option "without-check", "Skip compile-time tests."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # At some point it'd be nice to be able to "--disable-md5" but:
    # https://github.com/wolfSSL/wolfssl/issues/26
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ecc25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
    ]

    if MacOS.prefer_64_bit?
      args << "--enable-fastmath" << "--enable-fasthugemath"
    else
      args << "--disable-fastmath" << "--disable-fasthugemath"
    end

    args << "--enable-aesni" if Hardware::CPU.aes? && !build.bottle?

    # Extra flag is stated as a needed for the Mac platform.
    # http://yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.prefer_64_bit?

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
