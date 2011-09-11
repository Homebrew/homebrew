require 'formula'

class Jmeter < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=jakarta/jmeter/binaries/jakarta-jmeter-2.5.tgz'
  homepage 'http://jakarta.apache.org/jmeter/'
  md5 '18035ee0c8bf64792b2710d9ae48b2ac'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec #{libexec}/bin/#{name} $@
    EOS
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install %w{ LICENSE NOTICE README }
    libexec.install Dir['*']
    (bin+'jmeter').write startup_script('jmeter')
  end
end
