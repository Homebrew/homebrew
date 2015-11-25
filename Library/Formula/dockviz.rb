require "language/go"

class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git", :tag => "v0.3",
                                                :revision => "ae855d6a5a540c3563948e7035f9d19cab17f5b0"
  head "https://github.com/justone/dockviz.git"

  depends_on "go" => :build

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
        :revision => "0f5764b4d2f5b8928a05db1226a508817a9a01dd"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "0a28dbe50f23d8fce6b016975b964cfe7b97a20a"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockviz"
  end

  test do
    system "#{bin}/dockviz", "--version"
  end
end
