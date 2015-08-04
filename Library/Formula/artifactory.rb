class Artifactory < Formula
  desc "Manages binaries"
  homepage "http://www.jfrog.com/artifactory/"
  url "https://dl.bintray.com/jfrog/artifactory/jfrog-artifactory-oss-4.0.0.zip"
  sha256 "733b6f0f388099657cdf2429c41c7d8a91e8322346b811a97bedfb09036600dc"

  depends_on :java => "1.8+"

  option "with-low-heap", "Run artifactory with low Java memory options. Useful for development machines. Do not use in production."

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Set correct working directory
    inreplace "bin/artifactory.sh",
      'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
      "export ARTIFACTORY_HOME=#{libexec}"

    # Reduce memory consumption for non production use
    inreplace "bin/artifactory.default",
      "-server -Xms512m -Xmx2g",
      "-Xms128m -Xmx768m" if build.with? "low-heap"

    libexec.install Dir["*"]

    # Launch Script
    bin.install_symlink libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install_symlink libexec/"bin/artifactory.default"
  end

  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, we symlink the data dir to var.
    data = var/"artifactory"
    data.mkpath

    libexec.install_symlink data => "data"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/artifactory/libexec/bin/artifactory.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.jfrog.artifactory</string>

        <key>WorkingDirectory</key>
        <string>#{libexec}</string>

        <key>Program</key>
        <string>bin/artifactory.sh</string>

        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    output = shell_output("#{bin}/artifactory.sh check 2>&1", 1)
    assert_match /Checking arguments to Artifactory/, output
  end
end
