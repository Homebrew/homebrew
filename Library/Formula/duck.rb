class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh//duck-src-4.7.5.18825.tar.gz"
  sha256 "6edca55355cd5c12b07fa7163cf5ec0594f695a0569ca0740d54d1f958006948"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "357282a2d6092927a8dd133e9868646dffab55b339376280b8476d19cf7db6b8" => :el_capitan
    sha256 "fb45a7ae70bbf69a247563591deb6b5f8a305f4a2bf073bd216c4567cd6e3864" => :yosemite
    sha256 "6aaab98af32f261163510703ea45f15aeedc38fb81af648952a294ddf96c438a" => :mavericks
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Drevision=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["wget"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["wget"].stable.checksum
  end
end
