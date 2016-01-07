class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2016-01-05"

  stable do
    url "http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz"
    sha256 "be7794ed0cec42d6c682ca8e3517535b54555a3defabec83554dbc74db545ad5"

    resource "clang" do
      url "http://llvm.org/releases/3.7.1/cfe-3.7.1.src.tar.xz"
      sha256 "56e2164c7c2a1772d5ed2a3e57485ff73ff06c97dff12edbeea1acc4412b0674"
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz"
      sha256 "357fbd4288ce99733ba06ae2bec6f503413d258aeebaab8b6a791201e6f7f144"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6d48fca1fda278f2c14fa0e0a4266ad495d88e848315db3ca4615f7d7b437e74" => :el_capitan
    sha256 "7665ddb3a09455ed331d2aa99a3c51e3a9df2b71576fe1a46aa76523541c9b9b" => :yosemite
    sha256 "b76c50d116f7e0a1f76ad89cfe3e43ac0ac36107f24179a45ab1b3b7afb7bbd8" => :mavericks
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.7.1/libcxx-3.7.1.src.tar.xz"
      sha256 "357fbd4288ce99733ba06ae2bec6f503413d258aeebaab8b6a791201e6f7f144"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
    bin.install "tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir["tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<-EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
