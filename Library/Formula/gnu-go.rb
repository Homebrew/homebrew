require 'brewkit'

class GnuGo <Formula
  @url='http://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz'
  @homepage='http://www.gnu.org/software/gnugo/gnugo.html'
  @md5='6db0a528df58876d2b0ef1659c374a9a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=/usr/lib"
    system "make install"
  end
end
