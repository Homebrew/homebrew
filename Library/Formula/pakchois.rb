require 'formula'

class Pakchois < Formula
  homepage 'http://www.manyfish.co.uk/pakchois/'
  url 'http://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz'
  sha1 'dea8a9a50ec06595b498bdefd1daacdb86e9ceda'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
