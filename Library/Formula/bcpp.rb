require 'formula'

class Bcpp < Formula
  url 'ftp://invisible-island.net/bcpp/bcpp-20090630.tgz'
  homepage 'http://invisible-island.net/bcpp/'
  sha1 'f8ce9736fa2775e8c15b7fcbfee156103d90ece8'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
