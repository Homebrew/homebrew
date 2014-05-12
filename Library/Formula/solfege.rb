require 'formula'

class Solfege < Formula
  homepage 'http://www.solfege.org/'
  url 'http://ftpmirror.gnu.org/solfege/solfege-3.22.2.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/solfege/solfege-3.22.2.tar.xz'
  sha1 'd46e67d2f64c943fbdfa3858f077b49186a60a66'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'      => :build
  depends_on 'pygtk'        => :recommended
  depends_on 'qtplay'       => :recommended
  depends_on 'librsvg'      => :recommended
  depends_on 'vorbis-tools' => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make install'
  end

  def caveats
    <<-EOS.undent
      After installing Solfege, one of your programs, gdk-pixbuf, needs to be
      told to update its loader cache so it can read svg files. Run this once:

          export GDK_PIXBUF_MODULEDIR=#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders
          gdk-pixbuf-query-loaders --update-cache

      After doing that, you will be able to run solfege normally. You can go
      into Solfege Preferences and set your external programs to qtplay and
      ogg123 which get installed as dependencies, or you can use your own apps.
    EOS
  end
end
