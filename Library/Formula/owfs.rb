require 'formula'

class Owfs < Formula
  homepage 'http://owfs.org/'
  url 'http://sourceforge.net/projects/owfs/files/owfs/3.1p0/owfs-3.1p0.tar.gz'
  version '3.1p0'
  sha256 '62fca1b3e908cd4515c9eb499bf2b05020bbbea4a5b73611ddc6f205adec7a54'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-owtcl",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/owserver", "--version"
  end
end
