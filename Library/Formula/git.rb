require 'formula'

class GitManuals < Formula
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.11.2.tar.gz'
  sha1 '78b46ca7b5037c61a58086879869dadeac9eea3e'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.11.2.tar.gz'
  sha1 '088996c301cca24360fd5e30ce66bfa26139fe95'
=======
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.11.3.tar.gz'
  sha1 '10151406ace1da92a70d203a7eb1c86024fdd919'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.11.3.tar.gz'
  sha1 '41500708e87787d6139de413c4da91629aa79fa8'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://git-core.googlecode.com/files/git-manpages-1.7.12.tar.gz'
  sha1 'fb572729ca5c60161dc651564a50d4378507e20f'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.7.12.tar.gz'
  sha1 '50bbfeba77af9a411cc1a1e41220782cf3fd9b5e'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'http://git-core.googlecode.com/files/git-manpages-1.8.1.4.tar.gz'
  sha1 '98c41b38d02f09e1fcde335834694616d0a615f7'
end

class GitHtmldocs < Formula
  url 'http://git-core.googlecode.com/files/git-htmldocs-1.8.1.4.tar.gz'
  sha1 'bb71df6bc1fdb55b45c59af83102e901d484ef53'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40
end

class Git < Formula
  homepage 'http://git-scm.com'
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://git-core.googlecode.com/files/git-1.7.11.2.tar.gz'
  sha1 'f67b4f6c0277250411c6872ae7b8a872ae11d313'
=======
  url 'http://git-core.googlecode.com/files/git-1.7.11.3.tar.gz'
  sha1 'a10c420e4d9152d6059f41825904cfac3062b135'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://git-core.googlecode.com/files/git-1.7.12.tar.gz'
  sha1 '42ec1037f1ee5bfeb405710c83b73c0515ad26e6'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'http://git-core.googlecode.com/files/git-1.8.1.4.tar.gz'
  sha1 '553191fe02cfac77386d5bb01df0a79eb7f163c8'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  head 'https://github.com/git/git.git'

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'

  depends_on 'pcre' => :optional

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['NO_GETTEXT'] = '1'
    ENV['PERL_PATH'] = which 'perl' # workaround for users of perlbrew
    ENV['PYTHON_PATH'] = which 'python' # python can be brewed or unbrewed

    # Clean XCode 4.x installs don't include Perl MakeMaker
    ENV['NO_PERL_MAKEMAKER'] = '1' if MacOS.version >= :lion

    ENV['BLK_SHA1'] = '1' if build.include? 'with-blk-sha1'

    if build.with? 'pcre'
      ENV['USE_LIBPCRE'] = '1'
      ENV['LIBPCREDIR'] = HOMEBREW_PREFIX
    end

    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    # Install the OS X keychain credential helper
    cd 'contrib/credential/osxkeychain' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-credential-osxkeychain'
      system "make", "clean"
    end

    # Install git-subtree
    cd 'contrib/subtree' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-subtree'
    end

    # install the completion script first because it is inside 'contrib'
    bash_completion.install 'contrib/completion/git-completion.bash'
    bash_completion.install 'contrib/completion/git-prompt.sh'

    zsh_completion.install 'contrib/completion/git-completion.zsh' => '_git'
    ln_sf "#{etc}/bash_completion.d/git-completion.bash", zsh_completion

    (share+'git-core').install 'contrib'

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    GitManuals.new.brew { man.install Dir['*'] }
    GitHtmldocs.new.brew { (share+'doc/git-doc').install Dir['*'] }
  end

  def caveats; <<-EOS.undent
    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The 'contrib' directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      `#{bin}/git ls-files -- bin`.chomp == 'bin/brew'
    end
  end
end
