require 'formula'

class Pngcrush <Formula
  homepage 'http://pmt.sourceforge.net/pngcrush/'
  url "http://downloads.sourceforge.net/sourceforge/pmt/pngcrush-1.7.2.tar.bz2"
  md5 '24ead6781e7e017e8ee2bf61db93a355'

  def install
    # use our CFLAGS, LDFLAGS, CC, and LD
    inreplace 'Makefile' do |contents|
      contents.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
    end

    system "make"
    bin.install 'pngcrush'
  end
end
