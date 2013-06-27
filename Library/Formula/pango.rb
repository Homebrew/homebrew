require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.34/pango-1.34.1.tar.xz'
  sha256 '1aea30df34a8ae4fcce71afd22aa5b57224b52916d46e3ea81ff9f1eb130e64c'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'harfbuzz'

  unless build.include? 'without-x'
    depends_on :x11
    # Needs fontconfig 2.10.91, which is newer than what XQuartz provides
    depends_on 'fontconfig'
  end

  # The Cairo library shipped with Lion contains a flaw that causes Graphviz
  # to segfault. See the following ticket for information:
  #   https://trac.macports.org/ticket/30370
  # We depend on our cairo on all platforms for consistency
  depends_on 'cairo'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --disable-introspection
    ]

    if build.include? 'without-x'
      args << '--without-xft'
    else
      args << '--with-xft'
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pango-querymodules", "--version"
  end
end
