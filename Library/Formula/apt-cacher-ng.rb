require 'formula'

class AptCacherNg < Formula
  homepage 'http://www.unix-ag.uni-kl.de/~bloch/acng/'
  url 'http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.7.19.orig.tar.xz'
  sha256 '73df667ad5a742f603df7a0d9c3bb9600b6d7b9bc448553fd73fa41aa5563b27'

  depends_on 'xz' => :build
  depends_on 'cmake' => :build
  depends_on 'fuse4x' => :build
  depends_on 'boost' => :build

  def patches
    # waiting on http://alioth.debian.org/tracker/index.php?func=detail&aid=314521&group_id=100566&atid=413111
    DATA
  end

  def install
    system 'make apt-cacher-ng'

    inreplace 'conf/acng.conf' do |s|
      s.gsub! /^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng"
      s.gsub! /^LogDir: .*/, "LogDir: #{var}/log"
    end

    # copy default config over
    etc.install 'conf' => 'apt-cacher-ng'

    # create the cache directory
    (var/'spool/apt-cacher-ng').mkpath
    (var/'log').mkpath

    sbin.install 'build/apt-cacher-ng'
    man8.install 'doc/man/apt-cacher-ng.8'
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/apt-cacher-ng</string>
        <string>-c</string>
        <string>#{etc}/apt-cacher-ng</string>
        <string>foreground=1</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

end

__END__
--- a/source/bgtask.cc.orig	2013-11-10 16:57:42.000000000 +1000
+++ b/source/bgtask.cc	2013-11-10 16:48:23.000000000 +1000
@@ -44,7 +44,7 @@
 }

 // the obligatory definition of static members :-(
-weak_ptr<tWuiBgTask::tProgressTracker> tWuiBgTask::g_pTracker;
+SMARTPTR_SPACE::weak_ptr<tWuiBgTask::tProgressTracker> tWuiBgTask::g_pTracker;

 void _AddFooter(tSS &msg)
 {
