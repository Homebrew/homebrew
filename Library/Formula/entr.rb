class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.3.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.3.tar.gz"
  sha256 "701cb7b0a72b6c9ba794ad7cc15b6ebcc2e0c978bb6906c8ae407567a044461f"

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on :hg => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d57ec63310d25514226644b756fe21244b60fcece1343bd17a9f99c290c096cc" => :el_capitan
    sha256 "63939b37a28175656f51e6e99a5b37991eb6dd4cd2fe6464dc430dd038868ddc" => :yosemite
    sha256 "aebd4f88bb0d5162f18e6d851aedee11b77136cc528ea123288d79eec8e60ea8" => :mavericks
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS
    To increase the number of files `entr` is permitted to watch, run:

      sudo launchctl limit maxfiles 65536 524288

    Then copy the new property list file to make these limits permanent:

      sudo cp #{opt_prefix}/limit.maxfiles.plist /Library/LaunchDaemons/
    EOS
  end

  def plist_name(extra = nil)
    "limit.maxfiles"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>Label</key>
    <string>limit.maxfiles</string>
    <key>ProgramArguments</key>
    <array>
    <string>launchctl</string>
    <string>limit</string>
    <string>maxfiles</string>
    <string>65536</string>
    <string>524288</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>ServiceIPC</key>
    <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
  plist_options :manual => ""

      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
