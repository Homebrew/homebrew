require "formula"

class Mackup < Formula
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.1.tar.gz"
  sha1 "958308cc584cd0c734a620625c18f70fad333a47"

  head "https://github.com/lra/mackup.git"

  def install
    ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
