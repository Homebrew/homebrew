class KubernetesCli < Formula
  homepage "http://kubernetes.io/"
  url "https://github.com/GoogleCloudPlatform/kubernetes/archive/v0.12.1.tar.gz"
  sha256 "a119cfafe512fa6847dcd3ef728e5c7cd1a09cd83f2af8720d81d9e76c05d8c2"

  bottle do
    cellar :any
    sha1 "a81ab21c839f0c5b35b8ed18de07035c43fc8f44" => :yosemite
    sha1 "adf41773d958862c37c9daad73caca19bb74ba34" => :mavericks
    sha1 "e48cce8c577be6d684c5b2aadce9d1ade990fb3f" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/*", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl", "#{dir}/kubernetes"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
    assert_match %r{^Usage of #{bin}/kubernetes:}, shell_output("#{bin}/kubernetes --help 2>&1", 2)
  end
end
