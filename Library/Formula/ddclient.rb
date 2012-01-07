require 'formula'

class Ddclient < Formula
  url 'http://sourceforge.net/projects/ddclient/files/ddclient/ddclient-3.8.1/ddclient-3.8.1.tar.bz2'
  homepage 'http://sourceforge.net/apps/trac/ddclient'
  md5 '7fa417bc65f8f0e6ce78418a4f631988'

  def install
    # Adjust default paths in script
    inreplace 'ddclient' do |s|
      s.gsub! "/etc/ddclient", (etc + 'ddclient')
      s.gsub! "/var/cache/ddclient", (var + 'run/ddclient')
    end

    # Copy script to sbin
    sbin.install "ddclient"

    # Install sample files
    inreplace 'sample-ddclient-wrapper.sh',
      "/etc/ddclient", (etc + 'ddclient')

    inreplace 'sample-etc_cron.d_ddclient',
      "/usr/sbin/ddclient", (sbin + 'ddclient')

    inreplace 'sample-etc_ddclient.conf',
      "/var/run/ddclient.pid", (var + 'run/ddclient/pid')

    (share + 'doc/ddclient').install %w(
      sample-ddclient-wrapper.sh
      sample-etc_cron.d_ddclient
      sample-etc_ddclient.conf
    )

    # Create etc & var paths
    (etc + 'ddclient').mkpath
    (var + 'run/ddclient').mkpath

    # Write the launchd script
    (prefix + 'org.ddclient.plist').write startup_plist
    (prefix + 'org.ddclient.plist').chmod 0644
  end

  def caveats; <<-EOS
For ddclient to work, you will need to do the following:

1) Create configuration file in #{etc}/ddclient, a sample
   configuration can be found in #{HOMEBREW_PREFIX}/share/doc/ddclient.

   Note: don't enable daemon mode in the configuration file; see
   additional information below.

2) Install the launchd item in /Library/LaunchDaemons, like so:

   sudo cp -vf #{prefix}/org.ddclient.plist /Library/LaunchDaemons/
   sudo chown -v root:wheel /Library/LaunchDaemons/org.ddclient.plist

3) Start the daemon using:

  sudo launchctl load /Library/LaunchDaemons/org.ddclient.plist

The next reboot of the system will automatically start ddclient.

You can adjust the execution interval by changing the value of
StartInterval (in seconds) in /Library/LaunchDaemons/org.ddclient.plist,
and then

   sudo launchctl unload /Library/LaunchDaemons/org.ddclient.plist
   sudo launchctl load /Library/LaunchDaemons/org.ddclient.plist
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.ddclient</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{sbin}/ddclient</string>
    <string>-file</string>
    <string>#{etc}/ddclient/ddclient.conf</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>300</integer>
  <key>WatchPaths</key>
  <array>
    <string>#{etc}/ddclient</string>
  </array>
  <key>WorkingDirectory</key>
  <string>#{etc}/ddclient</string>
</dict>
</plist>
EOS
  end
end
