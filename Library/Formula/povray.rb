require 'formula'

class Povray < Formula
  url 'http://www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.1.tar.bz2'
  homepage 'http://www.povray.org/'
  md5 'b5789bb7eeaed0809c5c82d0efda571d'

  depends_on 'libtiff' => :optional
  depends_on 'jpeg' => :optional

  fails_with_llvm "llvm-gcc: povray fails with 'terminate called after throwing an instance of int'"

  def patches
    { :p0 => "https://gist.github.com/raw/940708/3d3d66a79c3f3b257eb8ed81d0ca8ae2b9e3311d/povray-patch-configure"}
  end

  def install
    config_args = [
      "--disable-debug", 
      "--disable-dependency-tracking",
      "COMPILED_BY=homebrew",
      "--prefix=#{prefix}",
      "--mandir=#{man}" 
    ]
    ENV.x11
    if MacOS.prefer_64_bit?
      ENV.m64 
      config_args << "--host=x86_64-darwin"
      config_args << "--build=x86_64-darwin"
    end
    system "./configure", *config_args
    system "make install"
  end
end
