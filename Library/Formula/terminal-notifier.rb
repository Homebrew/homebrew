require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.4.2.tar.gz'
  sha1 'eaa201650be05ff10aecde03df7f0acb161eefd8'

  head 'https://github.com/alloy/terminal-notifier.git'

  depends_on :xcode

  def patches
    DATA # Disable code signing because we don't have the cert of the dev.
  end

  def install
    system 'xcodebuild', "-project", "Terminal Notifier.xcodeproj",
                         "-target", "terminal-notifier",
                         "-verbose"
    prefix.install Dir['build/Release/*']
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, Pathname.new(bin+"terminal-notifier")
  end

  test do
    # Display a test notice
    system "#{bin}/terminal-notifier",
           "-title",     "Homebrew",
           "-subtitle",  "Test CLI Notification",
           "-message",   "Run terminal-notifier (sans args) for usage info",
           "-activate",  "com.apple.UserNotificationCenter"
      # We bind the notices' click event to a NOP, essentially,
      # by stipulating the ID of the notice widget's own app bundle
      # as that which it should 'activate'.
  end
end

__END__
diff --git a/Terminal Notifier.xcodeproj/project.pbxproj b/Terminal Notifier.xcodeproj/project.pbxproj
index 163020e..bc0597e 100644
--- a/Terminal Notifier.xcodeproj/project.pbxproj	
+++ b/Terminal Notifier.xcodeproj/project.pbxproj	
@@ -275,7 +275,6 @@
 		5199793415B1F92B003AFC57 /* Release */ = {
 			isa = XCBuildConfiguration;
 			buildSettings = {
-				CODE_SIGN_IDENTITY = "Developer ID Application: Fingertips B.V.";
 				COMBINE_HIDPI_IMAGES = YES;
 				GCC_PRECOMPILE_PREFIX_HEADER = YES;
 				GCC_PREFIX_HEADER = "Terminal Notifier/Terminal Notifier-Prefix.pch";
