class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://projects.universe-factory.net/projects/fastd"
  url "https://projects.universe-factory.net/attachments/download/81/fastd-17.tar.xz"
  sha256 "26d4a8bf2f8cc52872f836f6dba55f3b759f8c723699b4e4decaa9340d3e5a2d"
  head "git://git.universe-factory.net/fastd/"
  depends_on "cmake" => :build
  depends_on "libuecc"
  depends_on "libsodium"
  depends_on "bison" => :build # fastd requires bison >= 2.5
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl" => :optional

  def install
    mkdir "fastd-build" do
      if build.with? "openssl"
        system "cmake", "-DENABLE_LTO=ON -DENABLE_OPENSSL=ON", *std_cmake_args, ".."
      else
        system "cmake", "-DENABLE_LTO=ON", *std_cmake_args, ".."
      end
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/fastd"
  end
end
