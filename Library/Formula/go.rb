class Go < Formula
  desc "Go programming environment"
  homepage "https://golang.org"
  # Version 1.5 is going to require version 1.4 present to bootstrap 1.4
  # Perhaps we can use our previous bottles, ala the discussion around PyPy?
  # https://docs.google.com/document/d/1OaatvGhEAq7VseQ9kkavxKNAfepWy2yhPUBs96FGV28
  url "https://storage.googleapis.com/golang/go1.4.2.src.tar.gz"
  sha1 "460caac03379f746c473814a65223397e9c9a2f6"
  version "1.4.2"

  head "https://github.com/golang/go.git"

  devel do
    url "https://storage.googleapis.com/golang/go1.5beta1.src.tar.gz"
    sha256 "e02be87011421dc08ae6d03a3dc07492cad03faf83cb4f8ba8d39a403d38d3a1"
    version "1.5beta1"
  end

  bottle do
    revision 2
    sha256 "bb8b8e79201d93eb69e77763535b201ea812d426e259f106e18f62ddf80f86dd" => :yosemite
    sha256 "46fbe85b2c75e45686ee463eeaa975ce1604f04ee611815d7c163f5feee90e03" => :mavericks
    sha256 "7913ecbc952e22f9d6e5df114b857ed23ad97adcbc88419fa3b6425b856ee38e" => :mountain_lion
  end

  option "with-cc-all", "Build with cross-compilers and runtime support for all supported platforms"
  option "with-cc-common", "Build with cross-compilers and runtime support for darwin, linux and windows"
  option "without-cgo", "Build without cgo"
  option "without-godoc", "godoc will not be installed for you"
  option "without-vet", "vet will not be installed for you"

  deprecated_option "cross-compile-all" => "with-cc-all"
  deprecated_option "cross-compile-common" => "with-cc-common"

  resource "gotools" do
    url "https://go.googlesource.com/tools.git",
    :revision => "69db398fe0e69396984e3967724820c1f631e971"
  end

  resource "gobootstrap" do
    if MacOS.version > :lion
      url "https://storage.googleapis.com/golang/go1.4.2.darwin-amd64-osx10.8.tar.gz"
      sha1 "58a04b3eb9853c75319d9076df6f3ac8b7430f7f"
    else
      url "https://storage.googleapis.com/golang/go1.4.2.darwin-amd64-osx10.6.tar.gz"
      sha1 "00c3f9a03daff818b2132ac31d57f054925c60e7"
    end
  end

  def install
    # host platform (darwin) must come last in the targets list
    if build.with? "cc-all"
      targets = [
        ["linux",   ["386", "amd64", "arm"]],
        ["freebsd", ["386", "amd64", "arm"]],
        ["netbsd",  ["386", "amd64", "arm"]],
        ["openbsd", ["386", "amd64"]],
        ["windows", ["386", "amd64"]],
        ["dragonfly", ["386", "amd64"]],
        ["plan9",   ["386", "amd64"]],
        ["solaris", ["amd64"]],
        ["darwin",  ["386", "amd64"]],
      ]
    elsif build.with? "cc-common"
      targets = [
        ["linux",   ["386", "amd64", "arm"]],
        ["windows", ["386", "amd64"]],
        ["darwin",  ["386", "amd64"]],
      ]
    else
      targets = [["darwin", [""]]]
    end

    if build.head? || build.devel?
      # GOROOT_FINAL must be overidden later on real Go install
      ENV["GOROOT_FINAL"] = buildpath/"gobootstrap"

      # build the gobootstrap toolchain Go >=1.4
      (buildpath/"gobootstrap").install resource("gobootstrap")
      cd "#{buildpath}/gobootstrap/src" do
        system "./make.bash", "--no-clean"
      end
      # This should happen after we build the test Go, just in case
      # the bootstrap toolchain is aware of this variable too.
      ENV["GOROOT_BOOTSTRAP"] = ENV["GOROOT_FINAL"]
    end


    # The version check is due to:
    # http://codereview.appspot.com/5654068
    (buildpath/"VERSION").write("default") if build.head? || build.devel?

    cd "src" do
      targets.each do |os, archs|
        cgo_enabled = os == "darwin" && build.with?("cgo") ? "1" : "0"
        archs.each do |arch|
          ENV["GOROOT_FINAL"] = libexec
          ENV["GOOS"]         = os
          ENV["GOARCH"]       = arch
          ENV["CGO_ENABLED"]  = cgo_enabled
          ohai "Building go for #{arch}-#{os}"
          system "./make.bash", "--no-clean"
        end
      end
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/go*"]

    if build.with?("godoc") || build.with?("vet")
      ENV.prepend_path "PATH", bin
      ENV["GOPATH"] = buildpath
      (buildpath/"src/golang.org/x/tools").install resource("gotools")

      if build.with? "godoc"
        cd "src/golang.org/x/tools/cmd/godoc/" do
          system "go", "build"
          (libexec/"bin").install "godoc"
        end
        bin.install_symlink libexec/"bin/godoc"
      end

      if build.with? "vet"
        cd "src/golang.org/x/tools/cmd/vet/" do
          system "go", "build"
          # This is where Go puts vet natively; not in the bin.
          (libexec/"pkg/tool/darwin_amd64/").install "vet"
        end
      end
    end
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/"hello.go").write <<-EOS.undent
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello World")
    }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", `#{bin}/go run hello.go`

    if build.with? "godoc"
      assert File.exist?(libexec/"bin/godoc")
      assert File.executable?(libexec/"bin/godoc")
    end
    if build.with? "vet"
      assert File.exist?(libexec/"pkg/tool/darwin_amd64/vet")
      assert File.executable?(libexec/"pkg/tool/darwin_amd64/vet")
    end
  end
end
