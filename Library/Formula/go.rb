require 'formula'
require 'hardware'

class Go < Formula
  if ARGV.include? "--use-git-head"
    head 'https://github.com/tav/go.git', :tag => 'release'
  else
    head 'http://go.googlecode.com/hg/', :revision => 'release'
  end
  homepage 'http://golang.org'

  def options
    [["--use-git-head", "Use git mirror instead of official hg repository"]]
  end

  skip_clean 'bin'

  def install
    ENV.j1 # https://github.com/mxcl/homebrew/issues/#issue/237
    prefix.install %w[src include test doc misc lib favicon.ico]
    Dir.chdir prefix
    mkdir %w[pkg bin]

    Dir.chdir 'src' do
      system "./all.bash"
    end

    # Keep the makefiles - https://github.com/mxcl/homebrew/issues/issue/1404
    Dir['src/*'].each{|f| rm_rf f unless f.match(/^src\/(pkg|Make)/) }
    rm_rf %w[include test]
  end
  
  def caveats
    arch = Hardware.is_64_bit? ? 'amd64' : '386'
    <<-EOS.undent
    To export needed variables, add them to your dotfiles.
     * On Bash, add them to `~/.bash_profile`.
     * On Zsh, add them to `~/.zprofile` instead.
    
    export GOOS="darwin"
    export GOARCH="#{arch}"
    export GOROOT="#{prefix}"
    EOS
  end
end
