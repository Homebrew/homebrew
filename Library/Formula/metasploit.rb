require 'formula'

class Metasploit < Formula
  url "http://updates.metasploit.com/data/releases/framework-3.7.1.tar.bz2"
  version "3.7.1"
  homepage 'http://www.metasploit.com/framework/'
  sha1 '9a104bcacc8ecf683f5df16613da19076c81413c'

  def install
    libexec.install Dir["msf*",'data','external','lib','modules','plugins','scripts','test','tools']
    bin.mkpath
    Dir["#{libexec}/msf*"].each {|f| ln_s f, bin}
  end
end
