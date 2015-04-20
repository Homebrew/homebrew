require 'formula'

class Serd < Formula
  homepage 'http://drobilla.net/software/serd/'
  url 'http://download.drobilla.net/serd-0.20.0.tar.bz2'
  sha1 '38c0c8600270e38d99bc87b0ceb14b25c4c0cea3'

  bottle do
    cellar :any
    sha1 "cf8e4e7cba72fb4d05de1a6f75090aefb24c19a6" => :yosemite
    sha1 "734bc7cdd91ec765dcfa07404e0635c915fa52f8" => :mavericks
    sha1 "45ff9722f3d3f774c558c2b4dde77f811c596d0a" => :mountain_lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
