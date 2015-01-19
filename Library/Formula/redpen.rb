class Redpen < Formula
  homepage "http://redpen.cc/"
  url "https://github.com/recruit-tech/redpen/releases/download/v1.0.1/redpen-1.0.1.tar.gz"
  sha1 "df0324348af5e07840454cd088ea7d26f490e6bf"

  depends_on :java => "1.8"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]
    libexec.install %w[conf lib sample-doc]

    prefix.install "bin"
    java_home = `/usr/libexec/java_home`.chomp
    bin.env_script_all_files(libexec/"bin", :JAVA_HOME => java_home)
  end

  test do
    file_name = "sampledoc-en.txt"
    path = "#{libexec}/sample-doc/en/#{file_name}"
    output = `#{bin}/redpen -c #{libexec}/conf/redpen-conf-en.xml #{path}`
    errors = output.split("\n").select { |line| line.start_with?(file_name) }
    assert errors.find { |e|(e.start_with?("#{file_name}:1: ValidationError[SymbolWithSpace]")) }
  end
end
