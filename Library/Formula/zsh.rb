require 'brewkit'

class Zsh <Formula
  @url='http://downloads.sourceforge.net/project/zsh/zsh-dev/4.3.10/zsh-4.3.10.tar.gz'
  @homepage='http://www.zsh.org/'
  @md5='031efc8c8efb9778ffa8afbcd75f0152'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          # don't version stuff in Homebrew, we already do that!
                          "--enable-fndir=#{share}/zsh/functions",
                          "--enable-scriptdir=#{share}/zsh/scripts"

    # again don't version installation directories
    inreplace "Src/Makefile", "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"
    inreplace "Makefile", "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"
  end
  
  def skip_clean? path
    true
  end
end
