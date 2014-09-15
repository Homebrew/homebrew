require 'formula'

class Fish < Formula
  homepage 'http://fishshell.com'
  url 'http://fishshell.com/files/2.1.0/fish-2.1.0.tar.gz'
  sha1 'b1764cba540055cb8e2a96a7ea4c844b04a32522'

  head do
    url 'https://github.com/fish-shell/fish-shell.git'

    depends_on :autoconf
    # Indeed, the head build always builds documentation
    depends_on 'doxygen' => :build
  end

  skip_clean 'share/doc'

  def install
    # The Makefile automatically sets the shebang in the lexicon filter
    # using 'which'. In Homebrew's 'superenv' this will be incorrect, so
    # override it. Using 'inreplace' rather than a patch as it has a unique
    # signature in Makefile.in and require less maintenance in future.
    inreplace "Makefile.in", /\|@sed@\|[^|]*\|/, "|@sed@|/usr/bin/sed|" if build.head?

    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells. Run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end
end
