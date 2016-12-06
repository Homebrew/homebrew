require 'formula'

class SonarRunner < Formula
  homepage 'http://docs.codehaus.org/display/SONAR/Installing+and+Configuring+Sonar+Runner'
  url 'http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-runner/2.0/sonar-runner-2.0.zip'
  sha1 '3e483322985936b3724418bb696e7b74ef020cb8'
  
  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end
  
  def install
    # Remove windows files
    rm_rf Dir['bin/*.bat']
    libexec.install Dir['*']
    
    (bin+'sonar-runner').write startup_script('sonar-runner')
  end
  
  def caveats; <<-EOS.undent
      If this is your first install, you should adjust its default configuration:
        #{libexec}/conf/sonar-runner.properties

      after that you should also add a new enviroment variable
        SONAR_RUNNER_HOME=#{libexec}
      EOS
  end
  
  def test
    system "sonar-runner", "-h"
  end
end
