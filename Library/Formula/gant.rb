require 'formula'

class Gant < Formula
  homepage 'http://gant.codehaus.org/'
  url 'http://dist.codehaus.org/gant/distributions/gant-1.9.10-_groovy-2.2.0.zip'
  version '1.9.10'
  sha1 '90095416f659b626863b38acd4ca83d2ff65285a'

  depends_on 'groovy'

  def install
    rm_f Dir["bin/*.bat"]
    # gant-starter.conf is found relative to bin
    libexec.install %w[bin lib conf]
    bin.install_symlink "#{libexec}/bin/gant"
  end

  def caveats; <<-EOS.undent
    NOTE: You will recieve errors upon trying to use Gant unless you enter Gant's home directory into your .zshrc/.bashrc
    To do this paste in: export GANT_HOME="/usr/local/opt/gant/libexec"
    EOS
  end
end
