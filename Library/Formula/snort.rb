require "formula"

class Snort < Formula
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.7.0.tar.gz"
  sha1 "29eddcfaf8a4d02a4d68d88fa97c0275e4f0cc75"

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "daq"
  depends_on "libdnet"
  depends_on "pcre"
  depends_on "openssl"

  option "enable-debug", "Compile Snort with --enable-debug and --enable-debug-msgs"

  def install
    openssl = Formula["openssl"]

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-gre
      --enable-mpls
      --enable-targetbased
      --enable-sourcefire
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
      --enable-active-response
      --enable-normalizer
      --enable-reload
      --enable-react
      --enable-flexresp3
    ]

    if build.include? "enable-debug"
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end
