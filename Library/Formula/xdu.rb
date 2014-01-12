require "formula"

class Xdu < Formula
  homepage "http://sd.wareonearth.com/~phil/xdu/"
  url "http://sd.wareonearth.com/~phil/xdu/xdu-3.0.tar.Z"
  sha1 "196e2ba03253fd6b8a88fafe6b00e40632183d0c"

  depends_on "imake" => :build
  depends_on :x11

  def patches
    DATA
  end

  def install
    ENV["IMAKECPP"] = "cpp"
    ENV["DESTDIR"] = "#{prefix}"

    system "xmkmf"
    system "make install"
  end

end

__END__
diff -u a/Imakefile b/Imakefile
--- a/Imakefile
+++ b/Imakefile
@@ -7,6 +7,9 @@
 LOCAL_LIBRARIES = XawClientLibs
            SRCS = xdu.c xwin.c 
            OBJS = xdu.o xwin.o
+CCOPTIONS = -Wno-return-type
+PREPROCESSCMD = cpp
+XAWLIB = -L/usr/X11/lib -lXaw
 
 ComplexProgramTarget(xdu)
 InstallAppDefaults(XDu)
