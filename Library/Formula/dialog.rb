require 'formula'

class Dialog < Formula
  url 'ftp://invisible-island.net/dialog/dialog-1.1.20111020.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '494638fa36e5935a269ec9ab42677c30'
  version '1.1.20111020'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
