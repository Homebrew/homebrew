require 'formula'

def glib?
  ARGV.include? "--with-glib"
end

class PopplerData < Formula
  url 'http://poppler.freedesktop.org/poppler-data-0.4.4.tar.gz'
  md5 'f3a1afa9218386b50ffd262c00b35b31'
end

class Poppler < Formula
  url 'http://poppler.freedesktop.org/poppler-0.16.5.tar.gz'
  homepage 'http://poppler.freedesktop.org/'
  md5 '2b6e0c26b77a943df3b9bb02d67ca236'

  depends_on 'pkg-config' => :build
  depends_on "qt" if ARGV.include? "--with-qt4"
  depends_on 'cairo' if glib? # Needs a newer Cairo build than OS X 10.6.7 provides

  def options
    [
      ["--with-qt4", "Build Qt backend (which compiles all of Qt4!)"],
      ["--with-glib", "Build Glib backend"],
      ["--enable-xpdf-headers", "Also install XPDF headers."]
    ]
  end

  def install
    ENV.x11 # For Fontconfig headers

    if ARGV.include? "--with-qt4"
      ENV['POPPLER_QT4_CFLAGS'] = `pkg-config QtCore QtGui --libs`.chomp.strip
      ENV.append 'LDFLAGS', "-Wl,-F#{HOMEBREW_PREFIX}/lib"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--disable-poppler-qt4" unless ARGV.include? "--with-qt4"
    args << "--disable-poppler-glib" unless glib?
    args << "--enable-xpdf-headers" if ARGV.include? "--enable-xpdf-headers"

    system "./configure", *args
    system "make install"

    # Install poppler font data.
    PopplerData.new.brew do
      system "make install prefix=#{prefix}"
    end
  end
end
