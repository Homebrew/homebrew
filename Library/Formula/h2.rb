require 'formula'

class H2 < Formula
  version '1.3.174'
  homepage 'http://www.h2database.com/'
  url 'http://www.h2database.com/h2-2013-10-19.zip'
  sha1 '1788a1bfdf9316b5b7de4ae0649863d5a689edd4'

  def script; <<-EOS.undent
    #!/bin/sh
    cd #{libexec} && bin/h2.sh "$@"
    EOS
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the script
    chmod 0755, Dir["bin/h2.sh"]

    libexec.install Dir['*']
    (bin+'h2').write script
  end

  def caveats; <<-EOS.undent
    To start h2:
      h2

    Database web console is started on http://localhost:8082/
    To check the available options:
      h2 -help
    When running without options, -tcp, -web, -browser and -pg are started.
    EOS
  end

  plist_options :manual => 'h2'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/h2</string>
            <string>-tcp</string>
            <string>-web</string>
            <string>-pg</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
