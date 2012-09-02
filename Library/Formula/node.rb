require 'formula'

class NpmNotInstalled < Requirement
  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def message; <<-EOS.undent
      The homebrew node recipe now (beginning with 0.8.0) comes with npm.
      It appears you already have npm installed at #{modules_folder}/npm.
      To use the npm that comes with this recipe,
        first uninstall npm with `npm uninstall npm -g`.
        Then run this command again.

      If you would like to keep your installation of npm instead of
        using the one provided with homebrew,
        install the formula with the --without-npm option added.
    EOS
  end

  def satisfied?
    begin
      path = Pathname.new("#{modules_folder}/npm")
      not path.realpath.to_s.include?(HOMEBREW_CELLAR)
    rescue Exception => e
      true
    end
  end

  def fatal?
    true
  end
end

class Node < Formula
  homepage 'http://nodejs.org/'
<<<<<<< HEAD
<<<<<<< HEAD
  url 'http://nodejs.org/dist/v0.8.2/node-v0.8.2.tar.gz'
  sha1 '0e743d21b487151e67950f09198def058db19a1e'
=======
  url 'http://nodejs.org/dist/v0.8.5/node-v0.8.5.tar.gz'
  sha1 '835ba5ca429e56f65aeb1a5d9730fff105e86337'
>>>>>>> 1cd31e942565affb535d538f85d0c2f7bc613b5a
=======
  url 'http://nodejs.org/dist/v0.8.8/node-v0.8.8.tar.gz'
  sha1 '5ddafc059d2f774e35e6375f5b61157879a46f0f'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?
  depends_on NpmNotInstalled.new unless build.include? 'without-npm'

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'

  fails_with :llvm do
    build 2326
  end

  # Stripping breaks dynamic loading
  skip_clean :all

  def install
    args = %W{--prefix=#{prefix}}
    args << "--debug" if build.include? 'enable-debug'
    args << "--without-npm" if build.include? 'without-npm'

    system "./configure", *args
    system "make install"

    unless build.include? 'without-npm'
      (lib/"node_modules/npm/npmrc").write(npmrc)
    end
  end

  def npm_prefix
    "#{HOMEBREW_PREFIX}/share/npm"
  end

  def npm_bin
    "#{npm_prefix}/bin"
  end

  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def npmrc
    <<-EOS.undent
      prefix = #{npm_prefix}
    EOS
  end

  def caveats
    if build.include? 'without-npm'
      <<-EOS.undent
        Homebrew has NOT installed npm. We recommend the following method of
        installation:
          curl https://npmjs.org/install.sh | sh

        After installing, add the following path to your NODE_PATH environment
        variable to have npm libraries picked up:
          #{modules_folder}
      EOS
    elsif not ENV['PATH'].split(':').include? npm_bin
      <<-EOS.undent
        Homebrew installed npm.
        We recommend prepending the following path to your PATH environment
        variable to have npm-installed binaries picked up:
          #{npm_bin}
      EOS
    end
  end
end
