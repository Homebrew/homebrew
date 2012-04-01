require 'formula'

class Avocadodb < Formula
  url "https://github.com/triAGENS/AvocadoDB/zipball/v0.3.6"
  head "https://github.com/triAGENS/AvocadoDB.git"

  homepage 'http://www.avocadodb.org/'
  sha1 'e891adfba8c9ca118f4b94f7fb67cb2aea2fa7a4'

  depends_on 'libev'
  depends_on 'v8'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-relative",
                          "--disable-all-in-one",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--datadir=#{share}",
                          "--localstatedir=#{var}"

    system "make install"

    (var+'avocado').mkpath
  end

  def caveats; <<-EOS.undent
    Please note that this is a very early version if AvocadoDB. There will be
    bugs and the AvocadoDB team would really appreciate it if you report them:

      https://github.com/triAGENS/AvocadoDB/issues

    To start the AvocadoDB server, run:
        avocado

    To start the AvocadoDB shell, run:
        avocsh
    EOS
  end
end
