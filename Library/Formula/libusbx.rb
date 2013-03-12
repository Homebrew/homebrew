require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libusbx < Formula
  homepage 'http://libusbx.org'
  url 'http://downloads.sourceforge.net/project/libusbx/releases/1.0.14/source/libusbx-1.0.14.tar.bz2'
  sha1 '2896201c54a0a9d0aee724925ab58c96956d5251'

  conflicts_with 'libusb',
    :because => 'libusb and libusbx both install libusb-1.0.so'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal
  option 'no-runtime-logging', 'Build without runtime logging functionality'
  option 'with-default-log-level-debug' 'Build with default runtime log level of debug (instead of none)'

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--disable-log" if build.include?('no-runtime-logging')
    args << "--enable-debug-log" if build.include?('with-default-log-level-debug')
    system "./configure", *args
    system "make install"
  end
end
