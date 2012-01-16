require 'formula'

class Jshon < Formula
  url 'http://kmkeen.com/jshon/jshon.tar.gz'
  homepage 'http://kmkeen.com/jshon/'
  sha1 'db7ec186d48b2e1937f7b5fbb8dfda298997b32c'
  version '8'

  depends_on 'jansson'

  def install
    system "make"
    system "mkdir -p #{bin} #{prefix}/share/man/man1/"
    system "cp jshon #{bin}/"
    system "cp jshon.1 #{prefix}/share/man/man1/"
  end

  def test
    system "jshon"
  end
end
