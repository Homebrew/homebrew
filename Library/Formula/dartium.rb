require 'formula'

class Dartium < Formula
  homepage "https://www.dartlang.org"  
  ROOT_URL = "https://storage.googleapis.com/dart-archive/channels"
  release_version = '38663'
  base_url = "#{ROOT_URL}/stable/release/#{release_version}"
  version release_version
  url "#{base_url}/dartium/dartium-macos-ia32-release.zip"
  sha256 "25ecdbf0b80f362611fa76051db2cbff453bf8bd6fecaf2f71f6614d6907198d"
  
  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      open "#{prefix}/#{target}" "$@"
    EOS
  end

  def install
    name = "dartium"
    prefix.install Dir['*']
    (bin+name).write shim_script "Chromium.app"
  end

  def caveats; <<-EOS.undent
     To use with IntelliJ, set the Dartium execute home to:
        #{prefix}/Chromium
    EOS
  end

  test do
    system "#{bin}/dartium"
  end
end
