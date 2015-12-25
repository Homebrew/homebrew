class Rbenv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/rbenv/rbenv#readme"
  url "https://github.com/rbenv/rbenv/archive/v1.0.0.tar.gz"
  sha256 "4658f2d8604ef847b39cb8216bb0d8a8aa000f504b6d06b30e008f92e6fa5210"
  head "https://github.com/rbenv/rbenv.git"

  bottle :unneeded

  depends_on "ruby-build" => :recommended

  def install
    inreplace "libexec/rbenv" do |s|
      s.gsub!('"${BASH_SOURCE%/*}"/../libexec', libexec.to_s, false)
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub!(":/usr/local/etc/rbenv.d", ":#{HOMEBREW_PREFIX}/etc/rbenv.d\\0")
      end
    end

    # Compile optional bash extension. Failure is not critical.
    if File.exist? "src/configure"
      Kernel.system "src/configure"
      Kernel.system "make", "-C" "src"
    end

    if head?
      # Record exact git revision for `rbenv --version` output
      inreplace "libexec/rbenv---version" do |s|
        git_revision=`git rev-parse --short HEAD`.chomp
        s.sub!(/^(version=)"([^"]+)"/, %{\\1"\\2-g#{git_revision}"})
      end
    end

    prefix.install Dir["{bin,completions,libexec,rbenv.d}"]
  end

  def caveats; <<-EOS.undent
    Rbenv stores data under `~/.rbenv' by default. If you absolutely need to instead
    store everything under the Homebrew prefix, include this in your profile:
      export RBENV_ROOT=#{var}/rbenv

    To enable shims and autocompletion, run this and follow the instructions:
      rbenv init
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/rbenv init -)\" && rbenv versions")
  end
end
