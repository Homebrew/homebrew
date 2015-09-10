class AuroraScheduler < Formula
  desc "Apache Aurora Scheduler Client"
  homepage "https://aurora.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=aurora/0.9.0/apache-aurora-0.9.0.tar.gz"
  sha256 "16040866f3a799226452b1541892eb80ed3c61f47c33f1ccb0687fb5cf82767c"

  depends_on :python => :build

  def install
    ENV["LC_ALL"] = "en_US.UTF-8"
    if MacOS.version == :mountain_lion
      system "./pants", "binary", "src/main/python/apache/aurora/client/cli:kaurora"
      system "./pants", "binary", "src/main/python/apache/aurora/admin:kaurora_admin"
      bin.install "dist/kaurora.pex" => "aurora"
      bin.install "dist/kaurora_admin.pex" => "aurora_admin"
    else
      system "./pants", "binary", "src/main/python/apache/aurora/client/cli:aurora"
      system "./pants", "binary", "src/main/python/apache/aurora/admin:aurora_admin"
      bin.install "dist/aurora.pex" => "aurora"
      bin.install "dist/aurora_admin.pex" => "aurora_admin"
    end
  end

  test do
    system "aurora", "--version"
  end
end
