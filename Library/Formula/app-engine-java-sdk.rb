require 'formula'

class AppEngineJavaSdk < Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.5.0.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 'cc6ead54e170b33be2cf52c970915648e922f05b'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
end
