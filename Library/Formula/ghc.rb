require 'formula'

class Ghc < Formula
  homepage 'http://haskell.org/ghc/'
    url "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-x86_64-apple-darwin.tar.bz2"
    md5 'af89d3d2ca6e9b23384baacb7d8161dd'

    url "http://www.haskell.org/ghc/dist/7.0.4/ghc-7.0.4-i386-apple-darwin.tar.bz2"
    md5 'ce297e783d113cf1547386703d1b1061'


  devel do

      url "http://www.haskell.org/ghc/dist/7.4.1/ghc-7.4.1-x86_64-apple-darwin.tar.bz2"
      md5 '04a572f72c25e9d8fcbd7e9363d276bf'
   
  end

  # Avoid stripping the Haskell binaries & libraries.
  # See: http://hackage.haskell.org/trac/ghc/ticket/2458
  skip_clean ['bin', 'lib']

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Building with Clang configures GHC to use Clang as its preprocessor,
      which causes subsequent GHC-based builds to fail.
      EOS
  end



  def install
    if ARGV.build_devel?
      opoo "The current version of haskell-platform will NOT work with this version of GHC!"
    end

    end

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This brew is for GHC only; you might also be interested in haskell-platform.
    EOS
  end
end
