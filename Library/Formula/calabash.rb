require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-0.9.36.zip'
  md5 '82afd255063b3f9f2aec363fc89c011d'
  head 'git://github.com/ndw/xmlcalabash1.git'


  def install
    libexec.install Dir["*"]
    (bin+'calabash').write shim_script('calabash')
  end


  #
  # Copied & modified from `brew cat saxon`
  #
  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      java -Xmx1024m -jar #{libexec}/calabash.jar "$@"
    EOS

    # NOTE
    #
    #   The download comes a "bin" directory and an executable.
    #   Unfortunately, I don't know how to tell Homebrew to use
    #   it (or whether that's a good idea).
    #
    #   Please let me know how to do this (and whether it's a good
    #   idea)!  Message me on GitHub (I'm "Zearin").
    #
    #   (In the meantime, the code above worked for me.)
  end

  def test
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "calabash #{self.prefix}/xpl/pipe.xpl"
  end
end