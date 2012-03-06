require 'formula'

class GtkChtheme < Formula
  homepage 'http://plasmasturm.org/code/gtk-chtheme/'
  url 'http://plasmasturm.org/code/gtk-chtheme/gtk-chtheme-0.3.1.tar.bz2'
  md5 'f688053bf26dd6c4f1cd0bf2ee33de2a'

  depends_on 'cairo' 
  depends_on 'gdk-pixbuf' 
  depends_on 'gettext' 
  depends_on 'glib' 
  depends_on 'gtk+' 
  depends_on 'pango'

  def install
    # ENV.x11 # if your formula requires any X11 headers
    # ENV.j1  # if your formula's build system can't parallelize

    inreplace 'Makefile', '-DGTK_DISABLE_DEPRECATED', ''
    inreplace 'Metadata' do |s|
      s.change_make_var! "PREFIX", HOMEBREW_PREFIX
    end
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test gtk-chtheme`.
    system "false"
  end
end
