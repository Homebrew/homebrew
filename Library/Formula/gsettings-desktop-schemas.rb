require "formula"

class GsettingsDesktopSchemas < Formula
  homepage "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/"
  url "http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.12/gsettings-desktop-schemas-3.12.2.tar.xz"
  sha256 "da75021e9c45a60d0a97ea3486f93444275d0ace86dbd1b97e5d09000d8c4ad1"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib" => :build # Yep, for glib-mkenums
  depends_on "gobject-introspection" => :build
  depends_on "gettext"
  depends_on "libffi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--enable-introspection=yes"
    system "make install"
  end

  def post_install
    # manual schema compile step; put them in HOMEBREW_PREFIX, not the cellar
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  # Should (obviously) not segfault. See:
  # https://github.com/Homebrew/homebrew/issues/26455
  test do
    system bin/"gsettings", "list-schemas"
  end
end
