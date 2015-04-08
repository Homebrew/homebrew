require 'formula'

class Hidapi < Formula
  homepage "https://github.com/signal11/hidapi"
  url "https://github.com/signal11/hidapi/archive/hidapi-0.8.0-rc1.tar.gz"
  sha1 "5e72a4c7add8b85c8abcdd360ab8b1e1421da468"
 
  # This patch addresses a bug discovered in the HidApi IOHidManager back-end
  # that is being used with Macs.
  # The bug was dramatically changing the behaviour of the function
  # "hid_get_feature_report". As a consequence, many applications working
  # with HidApi were not behaving correctly on OSX.
  # pull request on Hidapi's repo: https://github.com/signal11/hidapi/pull/219
  patch do
    url "https://patch-diff.githubusercontent.com/raw/signal11/hidapi/pull/219.diff"
    sha256 "82631c8a6ec307482c09c133f9da89672c781665704304aa0ef286467b7fe5c2"
  end

  bottle do
    cellar :any
    sha1 "f3af3a129f163480bfa90d082a95cccd3469da5b" => :mavericks
    sha1 "39200d818b0b7889b351c781e4c94a42c3c749c4" => :mountain_lion
    sha1 "68edd3c5c191007340c14cae9537371e0b975f4a" => :lion
  end

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  def install
    system './bootstrap'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", "-lhidapi"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system './test'
  end
end
