require 'formula'

class Csscrush < Formula
  homepage 'http://the-echoplex.net/csscrush'
  url 'https://github.com/peteboere/css-crush/zipball/v1.4.1'
  md5 '10c03ffce864cd8cbf40256179a8592e'

  def install
    include.install Dir['*']
    (bin+'csscrush').write <<-EOS.undent
      #!/bin/sh
      php "#{include}/cli.php" $@
    EOS
  end

end
