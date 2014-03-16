require 'formula'

class AndroidSdk < Formula
  homepage 'http://developer.android.com/index.html'
  url 'http://dl.google.com/android/android-sdk_r22.6-macosx.zip'
  version '22.6'
  sha1 'f1da847ba793b38a510f9c9c70ff4baa5eba1427'

  conflicts_with 'android-platform-tools',
    :because => "the Platform-tools are be installed as part of the SDK."

  resource 'completion' do
    url 'https://raw.github.com/CyanogenMod/android_sdk/938c8d70af7d77dfcd1defe415c1e0deaa7d301b/bash_completion/adb.bash'
    sha1 '6dfead9b1350dbe1c16a1c80ed70beedebfa39eb'
  end

  def install
    prefix.install 'tools', 'SDK Readme.txt' => 'README'

    %w[android apkbuilder ddms dmtracedump draw9patch etc1tool emulator
    emulator-arm emulator-x86 hierarchyviewer hprof-conv lint mksdcard
    monitor monkeyrunner traceview zipalign].each do |tool|
      (bin/tool).write <<-EOS.undent
        #!/bin/sh
        TOOL="#{prefix}/tools/#{tool}"
        exec "$TOOL" "$@"
      EOS
    end

    # this is data that should be preserved across upgrades, but the Android
    # SDK isn't too smart, so we still have to symlink it back into its tree.
    %w[platforms samples temp add-ons sources system-images extras].each do |d|
      dst = prefix/d
      src = var/'lib/android-sdk'/d
      src.mkpath unless src.directory?
      dst.make_relative_symlink src
    end

    %w[adb fastboot].each do |platform_tool|
      (bin/platform_tool).write <<-EOS.undent
        #!/bin/sh
        PLATFORM_TOOL="#{prefix}/platform-tools/#{platform_tool}"
        test -f "$PLATFORM_TOOL" && exec "$PLATFORM_TOOL" "$@"
        echo Use the \\`android\\' tool to install the \\"Android SDK Platform-tools\\".
      EOS
    end

    %w[aapt aidl dexdump dx llvm-rs-cc].each do |build_tool|
      (bin/build_tool).write <<-EOS.undent
        #!/bin/sh
        BUILD_TOOLS_HOME="/usr/local/Cellar/android-sdk/22.6/build-tools"
        for DIR in $(ls -r "$BUILD_TOOLS_HOME")
        do
                BUILD_TOOL="$BUILD_TOOLS_HOME/$DIR/aapt"
                test -f "$BUILD_TOOL" && exec "$BUILD_TOOL" "$@" && break
        done
        echo Use the \\`android\\' tool to install the \\"Android SDK Build-tools\\".
      EOS
    end

    bash_completion.install resource('completion').files('adb.bash' => 'adb-completion.bash')
  end

  def caveats; <<-EOS.undent
    Now run the `android' tool to install the actual SDK stuff.

    The Android-SDK location for IDEs such as Eclipse, IntelliJ etc is:
      #{prefix}

    You will have to install the platform-tools and docs EVERY time this formula
    updates. If you want to try and fix this then see the comment in this formula.

    You may need to add the following to your .bashrc:
      export ANDROID_HOME=#{opt_prefix}
    EOS
  end

  # The `android' tool insists on deleting #{prefix}/platform-tools
  # and then installing the new one. So it is impossible for us to redirect
  # the SDK location to var so that the platform-tools don't have to be
  # freshly installed EVERY DANG time the base SDK updates.

  # Ideas: make android a script that calls the actual android tool, but after
  # that tool exits it repairs the directory locations?
end
