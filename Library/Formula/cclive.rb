require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz'
  sha1 '2bdee70f5e2026165ca444a306bb76fc5ede97b4'

  conflicts_with 'clozure-cl', :because => 'both install a ccl binary'

  devel do
    url 'http://downloads.sourceforge.net/project/cclive/0.9/cclive-0.9.2.tar.xz'
    sha1 '4c0671dd7c47dde5843b24dc5b9c59e93fe17b23'
  end

  head 'https://github.com/legatvs/cclive.git', :branch => 'next'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  if build.head?
    depends_on 'automake'
    depends_on 'autoconf'
    depends_on 'libtool'
    depends_on 'glibmm' => :build
    depends_on 'asciidoc' => :build
  end
  depends_on 'boost149'
  depends_on 'quvi'
  depends_on 'pcre'

  def patches
    DATA
  end if build.head?

  def install
    if build.head?
      (buildpath/'VERSION').write "v#{devel.version}"
      ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"
      system "./bootstrap.sh"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cclive", "-v"
  end
end

__END__

diff --git a/configure.ac b/configure.ac
index c9e6236..5f05f3e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -17,7 +17,7 @@ AC_USE_SYSTEM_EXTENSIONS
 AC_DEFINE_UNQUOTED([CANONICAL_TARGET], "$target",
   [Define to canonical target])
 
-AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip tar-ustar])
+AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip tar-ustar subdir-objects])
 AM_SILENT_RULES([yes])
 
 # GNU Automake 1.12 requires this macro. Earlier versions do not

diff --git a/bootstrap.sh b/bootstrap.sh
index 3bf84d6..5646fbf 100755
--- a/bootstrap.sh
+++ b/bootstrap.sh
@@ -60,4 +60,4 @@ do
 done
 
 echo "Generate configuration files..."
-autoreconf -if && echo "You can now run 'configure'"
+autoreconf -ifv && echo "You can now run 'configure'"

diff --git a/src/cc/error.h b/src/cc/error.h
index 2f2b559..6740618 100644
--- a/src/cc/error.h
+++ b/src/cc/error.h
@@ -39,7 +39,7 @@ namespace error
 static inline std::string strerror(const int ec)
 {
   char buf[256];
-  return strerror_r(ec, buf, sizeof(buf));
+  return (char*)strerror_r(ec, buf, sizeof(buf));
 }
