require 'formula'

class Slashem < Formula
  version "0.0.8E0F1"
  url 'http://downloads.sourceforge.net/project/slashem/slashem-source/0.0.8E0F1/se008e0f1.tar.gz'
  homepage 'http://slashem.sourceforge.net'
  md5 'cdfceaf7888246934dec8e256ac0a738'

  def patches
   # fixes compilation error in OS X - http://sourceforge.net/tracker/index.php?func=detail&aid=1644971&group_id=9746&atid=109746
   DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-owner=root",
                          "--with-group=staff"
    system "make install"
  end
end

__END__
diff --git a/win/tty/termcap.c b/win/tty/termcap.c
index c3bdf26..8d00b11 100644
--- a/win/tty/termcap.c
+++ b/win/tty/termcap.c
@@ -960,7 +960,7 @@ cl_eos()			/* free after Robert Viduya */
 
 #include <curses.h>
 
-#if !defined(LINUX) && !defined(__FreeBSD__)
+#if !defined(LINUX) && !defined(__FreeBSD__) && !defined(__APPLE__)
 extern char *tparm();
 #endif
