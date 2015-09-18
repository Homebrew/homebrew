class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "http://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/2.19.2.Final/forge-distribution-2.19.2.Final-offline.zip"
  version "2.19.2.Final"
  sha256 "be3b079ae57f3c3d9c18c6f1d8c0c71914e8fcdd09554321b93457e168572f58"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddf3d51ad0c59f4d627fa889b21d0044ebe93b09c605cde25cdf0d9ab282a99c" => :el_capitan
    sha256 "c33be3fc0799f9d1fee87301031ccb7808186965b9ce4a6b0429e78cb2b50349" => :yosemite
    sha256 "e1fee1c35f6d3846368397625f662bf76aa27d6cd1777aae4f55f820d35caf48" => :mavericks
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    ENV["FORGE_OPTS"] = "-Duser.home=#{testpath}"
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
