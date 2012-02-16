require 'formula'

class Mdxmini < Formula
  url 'https://github.com/BouKiCHi/mdxplayer/tarball/3e60c12666cd4fb5fe17bc0651ff883bd54644ad'
  md5 '80a3f96dbe84c19bf7e2042e7b8e819a'
  homepage 'http://clogging.web.fc2.com/psp/'
  version '20111115'

  depends_on 'sdl' unless ARGV.include? "--lib-only"

  def options
    [
      ["--lib-only", "Do not build commandline player"]
    ]
  end

  def install
    Dir.chdir "jni/mdxmini"
    # Specify Homebrew's cc
    inreplace "mak/general.mak", "gcc", ENV.cc
    if ARGV.include? "--lib-only"
      system "make -f Makefile.lib"
    else
      system "make"
    end

    # Makefile doesn't build a dylib
    system "#{ENV.cc} -dynamiclib -install_name #{lib}/libmdxmini.dylib -o libmdxmini.dylib -undefined dynamic_lookup obj/*.o"

    bin.install "mdxplay" unless ARGV.include? "--lib-only"
    lib.install "libmdxmini.a"
    lib.install "libmdxmini.dylib"
    (include+'libmdxmini').install Dir['src/*.h']
  end
end
