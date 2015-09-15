class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.19.1.Final/forge-distribution-2.19.1.Final-offline.zip"
  version "2.19.1.Final"
  sha256 "3047e54edd929262e80c31aeb8adc9f835395a102109a3653d690111c522c421"

  bottle do
    cellar :any
    sha256 "313805bbb8c57c9080418e93c8fcab563879f65842c45c37fc3e269c1402780e" => :yosemite
    sha256 "058bd3d6b6b50262028b5ea2e4438b4b800abb578422845bfbd8c73819d56d8f" => :mavericks
    sha256 "82cec34e430ccd330c5928080521988cf654944ddd379014993aa37f03996ef1" => :mountain_lion
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin img lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    ENV["FORGE_OPTS"] = "-Duser.home=#{testpath}"
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
