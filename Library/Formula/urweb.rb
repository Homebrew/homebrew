require 'formula'

class Urweb < Formula
  homepage 'http://impredicative.com/ur/'
  url 'http://impredicative.com/ur/urweb-20120807.tgz'
  md5 'c4860d5a72f1ef7754f180a25f77b915'
  head 'http://hg.impredicative.com/urweb', :using => :hg

  depends_on :automake
  depends_on :libtool

  depends_on 'mlton'

  def install
    system "aclocal"
    system "autoreconf -i --force"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Programs generated by the Ur/Web compiler can use SQLite,
    PostgreSQL, or MySQL for the data store. You probably want to
    install either PostgreSQL or MySQL if you're going to deploy
    real apps or test them heavily.
    EOS
  end
end
