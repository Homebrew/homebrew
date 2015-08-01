class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://code.google.com/p/pulledpork/"
  url "https://pulledpork.googlecode.com/files/pulledpork-0.7.0.tar.gz"
  sha1 "fd7f2b195b473ba80826c4f06dd6ef2dd445814e"
  head "http://pulledpork.googlecode.com/svn/trunk/"

  depends_on "Switch" => :perl

  def install
    bin.install "pulledpork.pl"
    doc.install Dir["doc/*"]
    etc.install Dir["etc/*"]
  end
end
