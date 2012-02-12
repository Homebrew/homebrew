require 'formula'

class Fmdiff < Formula
  url 'http://www.defraine.net/~brunod/fmdiff/fmscripts-20110714.tar.gz'
  md5 '54b5ed94c89acd309effd37187414593'
  homepage 'http://www.defraine.net/~brunod/fmdiff/'

  head 'http://soft.vub.ac.be/svn-gen/bdefrain/fmscripts/', :using => :svn

  def install
    bin.install Dir["fm*"]
  end
end
