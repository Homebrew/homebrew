require 'formula'

class Ngspice < Formula
  homepage 'http://ngspice.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ngspice/ng-spice-rework/26/ngspice-26.tar.gz'
  sha1 '7c043c604b61f76ad1941defeeac6331efc48ad2'

  option "with-x", "Build with X support"
  option "without-xspice", "Build without x-spice extensions"

  depends_on :x11 if MacOS::X11.installed? or build.include? "with-x"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-editline=yes
    ]
    args << "--enable-x" if build.include? "with-x"
    args << "--enable-xspice" unless build.include? "without-xspice"

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/ngspice", "-v"
  end
end
