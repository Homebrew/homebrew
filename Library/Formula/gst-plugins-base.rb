require 'formula'

class GstPluginsBase < Formula
  homepage 'http://gstreamer.freedesktop.org/'
  url 'http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.0.8.tar.xz'
  mirror 'http://ftp.osuosl.org/pub/blfs/svn/g/gst-plugins-base-1.0.8.tar.xz'
  sha256 'b55c9deea00acf789f82845c088b7c7c17b3ecef24a94831a819071b3dd8ef0d'

  head 'git://anongit.freedesktop.org/gstreamer/gst-plugins-base'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'gettext'
  depends_on 'gstreamer'

  # The set of optional dependencies is based on the intersection of
  # gst-plugins-base-0.10.35/REQUIREMENTS and Homebrew formulae
  depends_on 'gobject-introspection' => :optional
  depends_on 'orc' => :optional
  depends_on 'gtk+' => :optional
  depends_on 'libogg' => :optional
  depends_on 'pango' => :optional
  depends_on 'theora' => :optional
  depends_on 'libvorbis' => :optional

  def install
    ENV.append "NOCONFIGURE", "yes" if build.head?

    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
    ]

    args << "--enable-debug" if build.head?
    args << "--enable-dependency-tracking" if build.head?

    args << "--disable-debug" if not build.head?
    args << "--disable-dependency-tracking" if not build.head?

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make install"
  end
end
