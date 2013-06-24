require 'formula'

class Mimms < Formula
  homepage 'http://savannah.nongnu.org/projects/mimms/'
  url 'https://launchpad.net/mimms/trunk/3.2.1/+download/mimms-3.2.1.tar.bz2'
  sha1 '279eee76dd4032cd2c1dddf1d49292a952c57b80'

  depends_on :python
  depends_on 'libmms'

  # Switch shared library loading to Mach-O naming convention (.dylib)
  # Fix installation path for man page to $(brew --prefix)/share/man
  def patches
     DATA
  end

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  def caveats
    python.standard_caveats if python
  end

  test do
    system "#{HOMEBREW_PREFIX}/share/python/mimms", "--version"
  end
end
__END__
diff --git a/libmimms/libmms.py b/libmimms/libmms.py
index fb59207..ac42ba4 100644
--- a/libmimms/libmms.py
+++ b/libmimms/libmms.py
@@ -23,7 +23,7 @@ exposes the mmsx interface, since this one is the most flexible.
 
 from ctypes import *
 
-libmms = cdll.LoadLibrary("libmms.so.0")
+libmms = cdll.LoadLibrary("libmms.0.dylib")
 
 # opening and closing the stream
 libmms.mmsx_connect.argtypes = [c_void_p, c_void_p, c_char_p, c_int]

diff --git a/setup.py b/setup.py
index cfeb678..f6f92f0 100644
--- a/setup.py
+++ b/setup.py
@@ -10,6 +10,6 @@ setup(
   packages=['libmimms'],
   scripts=['mimms'],
   data_files=[
-    ('share/man/man1', ['mimms.1'])
+    ('man/man1', ['mimms.1'])
     ]
   )
