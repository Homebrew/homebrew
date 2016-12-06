# -*- coding: utf-8 -*-
require 'formula'

class Unac < Formula
  homepage 'http://savannah.nongnu.org/projects/unac'
  url 'http://ftp.de.debian.org/debian/pool/main/u/unac/unac_1.8.0.orig.tar.gz'
  sha1 '3e779bb7f3b505880ac4f43b48ee2f935ef8aa36'

  depends_on 'gettext' => :build
  depends_on :autoconf => :build
# requires a newer automake than 1.10
  depends_on :automake => :build
  depends_on :libtool => :build

  def patches
    {
      :p0 => ["http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=patch-libunac1.txt;att=1;bug=623340",
        "http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=patch-unaccent.c.txt;att=1;bug=623340"],
      :p1 => ["http://ftp.de.debian.org/debian/pool/main/u/unac/unac_1.8.0-6.diff.gz",
	DATA]
    }
  end

  def install
    system "chmod","+x","./configure"
    touch "config.rpath"
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    system "make install"
  end

  def test
    `#{bin}/unaccent utf-8 fóó`.chomp == 'foo'
  end
end

#
# configure.ac doesn't properly detect Mac OS's iconv library. This patch fixes that.
#
__END__
diff --git a/configure.ac b/configure.ac
index 4a4eab6..9f25d50 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,6 +49,7 @@ AM_MAINTAINER_MODE
 
 AM_ICONV
 
+LIBS="$LIBS -liconv"
 AC_CHECK_FUNCS(iconv_open,,AC_MSG_ERROR([
 iconv_open not found try to install replacement from
 http://www.gnu.org/software/libiconv/
