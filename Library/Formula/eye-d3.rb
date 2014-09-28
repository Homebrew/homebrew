require 'formula'

class EyeD3 < Formula
  homepage 'http://eyed3.nicfit.net/'
  url 'http://eyed3.nicfit.net/releases/eyeD3-0.7.5.tgz'
  sha1 'bcfd0fe14f5fa40f29ca7e7133138a5112f3c270'
  def install
    # Manually process this file
    inreplace "src/eyeD3/__init__.py" do |s|
      s.change_make_var! "eyeD3Version", "\"#{version}\""
      s.change_make_var! "eyeD3Maintainer", "\"Packaged by Homebrew\""
    end

    libexec.install "src/eyeD3"
    libexec.install "bin/eyeD3" => "eyeD3_script"
    bin.install_symlink libexec+"eyeD3_script" => "eyeD3"
  end
end
