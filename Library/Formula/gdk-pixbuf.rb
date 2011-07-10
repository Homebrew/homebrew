require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.22/gdk-pixbuf-2.22.1.tar.bz2'
  md5 '716c4593ead3f9c8cca63b8b1907a561'

  depends_on 'glib'
  depends_on 'jasper'
  depends_on 'libtiff'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libjasper",
                          "--enable-introspection=no"
    system "make install"
  end
end

__END__
diff --git a/gdk-pixbuf/io-png.c b/gdk-pixbuf/io-png.c
index 79c81fd..b195f5e 100644
--- a/gdk-pixbuf/io-png.c
+++ b/gdk-pixbuf/io-png.c
@@ -183,7 +183,7 @@ png_simple_error_callback(png_structp png_save_ptr,
                              error_msg);
         }
 
-        longjmp (png_save_ptr->jmpbuf, 1);
+        png_longjmp (png_save_ptr, 1);
 }
 
 static void
@@ -287,7 +287,7 @@ gdk_pixbuf__png_image_load (FILE *f, GError **error)
 		return NULL;
 	}
 
-	if (setjmp (png_ptr->jmpbuf)) {
+	if (setjmp (png_jmpbuf(png_ptr))) {
 	    	g_free (rows);
 
 		if (pixbuf)
@@ -459,7 +459,7 @@ gdk_pixbuf__png_image_begin_load (GdkPixbufModuleSizeFunc size_func,
                 return NULL;
         }
         
-	if (setjmp (lc->png_read_ptr->jmpbuf)) {
+	if (setjmp (png_jmpbuf(lc->png_read_ptr))) {
 		if (lc->png_info_ptr)
 			png_destroy_read_struct(&lc->png_read_ptr, NULL, NULL);
                 g_free(lc);
@@ -531,7 +531,7 @@ gdk_pixbuf__png_image_load_increment(gpointer context,
         lc->error = error;
         
         /* Invokes our callbacks as needed */
-	if (setjmp (lc->png_read_ptr->jmpbuf)) {
+	if (setjmp (png_jmpbuf(lc->png_read_ptr))) {
                 lc->error = NULL;
 		return FALSE;
 	} else {
@@ -769,7 +769,7 @@ png_error_callback(png_structp png_read_ptr,
                              error_msg);
         }
 
-        longjmp (png_read_ptr->jmpbuf, 1);
+        png_longjmp (png_read_ptr, 1);
 }
 
 static void
@@ -978,7 +978,7 @@ static gboolean real_save_png (GdkPixbuf        *pixbuf,
 	       success = FALSE;
 	       goto cleanup;
        }
-       if (setjmp (png_ptr->jmpbuf)) {
+       if (setjmp (png_jmpbuf(png_ptr))) {
 	       success = FALSE;
 	       goto cleanup;
        }

