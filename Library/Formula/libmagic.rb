require 'formula'

class Libmagic < Formula
  url 'ftp://ftp.astron.com/pub/file/file-5.10.tar.gz'
  homepage 'http://www.darwinsys.com/file/'
  sha1 '72fd435e78955ee122b7b3d323ff2f92e6263e89'

  def install
    # don't dupe this system utility -- call it gfile
    # and this formula is called "libmagic" not "file"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--enable-fsect-man5", "--program-prefix=g"
    system "make"
    ENV.j1 # Remove some warnings during install
    system "make install"
  end
end
