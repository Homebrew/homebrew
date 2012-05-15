require 'formula'

class Jenkins < Formula
  homepage 'http://jenkins-ci.org'
  url 'http://mirrors.jenkins-ci.org/war/1.462/jenkins.war'
  version '1.462'
  md5 '06c219c7f23f20c5f153566ee017a8cc'

  head 'https://github.com/jenkinsci/jenkins.git'

  def install
    system "mvn clean install -pl war -am -DskipTests && mv war/target/jenkins.war ." if ARGV.build_head?
    libexec.install "jenkins.war"
    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
      launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start it manually:
      java -jar #{libexec}/jenkins.war
    EOS
  end

  def startup_plist; <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>EnvironmentVariables</key>
  <dict>
  <key>SSH_AUTH_SOCK</key>
  <string>$SSH_AUTH_SOCK</string>
  </dict>
  <key>ProgramArguments</key>
  <array>
  <string>/usr/bin/java</string>
  <string>-jar</string>
  <string>#{libexec}/jenkins.war</string>
  <string>--httpListenAddress=127.0.0.1</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOS
  end
end
