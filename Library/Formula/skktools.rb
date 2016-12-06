require 'formula'

class Skktools < Formula
  homepage 'http://openlab.jp/skk/index-j.html'
  url 'http://openlab.ring.gr.jp/skk/tools/skktools-1.3.2.tar.gz'
  sha256 'cd1cc9d6d9674d70bbc69f52ac1d1a99a8067dd113a0fa1d50685a29e58a6791'

  depends_on 'glib'

  def install

    args = ["--with-skkdic-expr2",
            "--prefix=#{prefix}",
           ]

    glib = Formula.factory('glib')
    ENV.append 'CFLAGS', "-I#{HOMEBREW_PREFIX}/include"
    ENV.append 'CFLAGS', "-I#{glib.include}/glib-2.0 -I#{glib.include}/glib-2.0/glib -I/usr/local/Cellar/glib/2.30.2/lib/glib-2.0/include -lglib-2.0 -lintl -liconv"

    system "./configure", *args

    # replace Makefile Target
    inreplace 'Makefile' do |s|
      s.gsub! 'TARGETS = skkdic-expr$(EXEEXT)', 'TARGETS = skkdic-expr$(EXEEXT) skkdic-expr2$(EXEEXT)'
    end

    system "make"
    ENV.j1
    system "make install"
  end

end
