require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.1.tar.gz'
  sha1 'e377cbe989cd22d3a10020309c906ecbbcac0043'

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  # Patch adapted from Macports patch for 2.9.0 defines sizeof based on __LP64__
  # Fixes universal builds but seems groovy enough to apply in all cases.
  # https://trac.macports.org/browser/trunk/dports/graphics/fontconfig/files/patch-check-arch-at-runtime.diff
  def patches; DATA; end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/src/fcarch.h	2012-07-23 19:01:32.000000000 -0700
+++ b/src/fcarch.h	2012-10-20 10:29:15.000000000 -0700
@@ -46,6 +46,19 @@
  * be64		1234		8		8
  */

+#ifdef __APPLE__
+# include <machine/endian.h>
+# undef SIZEOF_VOID_P
+# undef ALIGNOF_DOUBLE
+# ifdef __LP64__
+#  define SIZEOF_VOID_P 8
+#  define ALIGNOF_DOUBLE 8
+# else
+#  define SIZEOF_VOID_P 4
+#  define ALIGNOF_DOUBLE 4
+# endif
+#endif
+
 #if defined(__DARWIN_BYTE_ORDER) && __DARWIN_BYTE_ORDER == __DARWIN_LITTLE_ENDIAN
 # define FC_ARCH_ENDIAN "le"
 #elif defined(__DARWIN_BYTE_ORDER) && __DARWIN_BYTE_ORDER == __DARWIN_BIG_ENDIAN
--- a/fonts.conf.in	2012-10-29 23:15:08.000000000 +0800
+++ b/fonts.conf.in	2012-10-29 23:15:10.000000000 +0800
@@ -23,6 +23,8 @@
 
 <!-- Font directory list -->
 
+	<dir>/Library/Fonts</dir>
+	<dir>~/Library/Fonts</dir>
 	<dir>@FC_DEFAULT_FONTS@</dir>
 	@FC_FONTPATH@
 	<dir prefix="xdg">fonts</dir>
