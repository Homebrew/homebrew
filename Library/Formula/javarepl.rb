require 'formula'

class Javarepl < Formula
  homepage "https://github.com/albertlatacz/java-repl"
  url "http://albertlatacz.published.s3.amazonaws.com/repo/javarepl/javarepl/272/javarepl-272.jar"
  sha1 "d9528b0def103694c83bdded0a8d103edb175b4e"

  def install
    libexec.install "javarepl-#{version}.jar"
    bin.write_jar_script libexec/"javarepl-#{version}.jar", "javarepl"
  end

  test do
    IO.popen(bin/"javarepl", "w+") do |pipe|
      pipe.write "System.out.println(64*1024)\n:quit\n"
      pipe.close_write
      assert pipe.read.include?("65536")
    end
  end
end
