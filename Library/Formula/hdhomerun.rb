require 'formula'

class Hdhomerun < Formula
  homepage 'http://www.silicondust.com/'
  url 'http://download.silicondust.com/hdhomerun/libhdhomerun_20130328.tgz'
  sha1 '005b0771a94bf2f1a2ce4765b16a1fa636df77cb'

  def patches
    # fixes the compiler warnings with the default Makefile
    DATA
  end

  def install
    system "make"
    bin.install 'hdhomerun_config'
    lib.install 'libhdhomerun.dylib'
    include.install Dir['*.h']
  end
end

__END__
diff --git a/Makefile b/Makefile
index dfda53f..2ec8ee5 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,6 @@ else
     LDFLAGS += -lsocket
   endif
   ifeq ($(OS),Darwin)
-    CFLAGS += -arch i386 -arch ppc
     LIBEXT := .dylib
     SHARED := -dynamiclib -install_name libhdhomerun$(LIBEXT)
   endif
