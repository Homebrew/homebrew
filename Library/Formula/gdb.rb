class UniversalBrewedPython < Requirement
  satisfy { archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python was requested, but Python is not
    a universal build.

    GDB requires Python to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class UniversalBrewedPython3 < Requirement
  satisfy { archs_for_command("python3").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python3 was requested, but Python3 is not
    a universal build.

    GDB requires Python3 to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "http://ftpmirror.gnu.org/gdb/gdb-7.10.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.10.1.tar.xz"
  sha256 "25c72f3d41c7c8554d61cacbeacd5f40993276d2ccdec43279ac546e3993d6d5"

  bottle do
    sha256 "380d33fdf8f3c0716e3b9307e60cde1d1a66d2cfebdd5306949c483c870f8a30" => :el_capitan
    sha256 "2953ed51376554c7147dc4a01fba9f76ed3c8e6fa45bf9ab006159429d3b7780" => :yosemite
    sha256 "1c48758042eed1ba9357fdb98b49b5b819555d664f9bb876e35c8bbaad58b0ec" => :mavericks
  end

  option "with-brewed-python", "Use the Homebrew version of Python"
  option "with-brewed-python3", "Use the Homebrew version of Python3"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "xz"
  depends_on "guile" => :optional

  if build.with? "brewed-python"
    depends_on UniversalBrewedPython
  end

  if build.with? "brewed-python3"
    depends_on UniversalBrewedPython3
    patch :p1, :DATA
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-lzma",
    ]

    args << "--with-system-readline" if build.with? "brewed-pyhon"
    args << "--with-guile" if build.with? "guile"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "brewed-python"
      args << "--with-python=#{HOMEBREW_PREFIX}/bin/python"
    elsif build.with? "brewed-python3"
      args << "--with-python=#{HOMEBREW_PREFIX}/bin/python3"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Remove conflicting items with binutils
    rm_rf include
    rm_rf lib
    rm_rf share/"locale"
    rm_rf share/"info"
  end

  def caveats; <<-EOS.undent
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      http://sourceware.org/gdb/wiki/BuildingOnDarwin
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
__END__
diff --git a/gdb/python/python-config.py b/gdb/python/python-config
--- a/gdb/python/python-config.py	2015-12-18 22:46:55.000000000 +0800
+++ b/gdb/python/python-config.py	2015-12-18 22:47:22.000000000 +0800
@@ -72,7 +72,5 @@
                     libs.insert(0, '-L' + getvar('LIBPL'))
                 elif os.name == 'nt':
                     libs.insert(0, '-L' + sysconfig.PREFIX + '/libs')
-            if getvar('LINKFORSHARED') is not None:
-                libs.extend(getvar('LINKFORSHARED').split())
         print (to_unix_path(' '.join(libs)))
