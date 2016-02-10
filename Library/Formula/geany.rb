class Geany < Formula
  desc "Basic text editor with IDE support"
  homepage "http://geany.org/"
  url "http://download.geany.org/geany-1.24.1.tar.gz"
  sha256 "8aa5dbf94b5252fce2ba504b47addb047a076fe44f11a08be45dc59e7ac318ba"
  revision 1

  bottle do
    sha256 "eae5d8d94e04571232f87cb22a0d6e8c7d4aacbe0284b7127e36b4e8c4fc434e" => :el_capitan
    sha256 "ea08a27a408d1cbc1389c9b4010ecd48faf7cfb944850c709bf736012398b640" => :yosemite
    sha256 "7450b524185d6e9beb237e8c73af6b47299ebbd70f4fb048957076d3042db51e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # main executable test (GUI)
    system "#{bin}/geany", "--version"
    # API test
    (testpath/"test.c").write <<-EOS.undent
      #include <geanyplugin.h>
      PLUGIN_SET_INFO("HelloWorld", "Just another tool to say hello world", "1.0", "Joe Doe <joe.doe@example.org>");
      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{include}/geany
      -I#{include}/geany/scintilla
      -I#{include}/geany/tagmanager
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DGTK
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
