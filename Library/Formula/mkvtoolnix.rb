require "formula"

class Ruby19 < Requirement
  fatal true
  default_formula "ruby"

  satisfy :build_env => false do
    next unless which "ruby"
    version = /\d\.\d/.match `ruby --version 2>&1`
    next unless version
    Version.new(version.to_s) >= Version.new("1.9")
  end

  def modify_build_environment
    ruby = which "ruby"
    return unless ruby
    ENV.prepend_path "PATH", ruby.dirname
  end

  def message; <<-EOS.undent
    The mkvtoolnix buildsystem needs Ruby >=1.9
    EOS
  end
end

class Mkvtoolnix < Formula
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-7.3.0.tar.xz"
  sha1 "c5379fa684a0a5e6cf0db7404b72e7075989a1a3"

  bottle do
    sha1 "ff8ace4ece6cab820a40bc8f6761f4191ca7537c" => :yosemite
    sha1 "90aa55113865e9e67d70ec7181c70f63b396be56" => :mavericks
    sha1 "abc98a3d670d5aacac8232645027a20c8edc0a98" => :mountain_lion
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-preview-gui", "Build with experimental QT GUI"

  depends_on "pkg-config" => :build
  depends_on Ruby19
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "expat"
  depends_on "pcre"
  depends_on "flac" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "lzo" => :optional
  depends_on "wxmac" => :optional
  depends_on "gettext" => :optional
  # On Mavericks, the bottle (without c++11) can be used
  # because mkvtoolnix is linked against libc++ by default
  if MacOS.version >= "10.9"
    depends_on "boost"
    depends_on "libmatroska"
    depends_on "libebml"
  else
    depends_on "boost" => "c++11"
    depends_on "libmatroska" => "c++11"
    depends_on "libebml" => "c++11"
  end

  if build.with?("preview-gui")
    depends_on "qt5"
  end

  needs :cxx11

  def install
    ENV.cxx11

    ENV["ZLIB_CFLAGS"] = "-I/usr/include"
    ENV["ZLIB_LIBS"] = "-L/usr/lib -lz"

    boost = Formula["boost"]

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --without-curl
      --with-boost=#{boost.opt_prefix}
    ]

    if build.with? "wxmac"
      wxmac = Formula["wxmac"]

      args << "--enable-gui"
      args << "--enable-wxwidgets"
    else
      args << "--disable-wxwidgets"
    end

    if build.with?("preview-gui")
      qt5 = Formula["qt5"]

      args << "--with-moc=#{qt5.opt_bin}/moc"
      args << "--with-uic=#{qt5.opt_bin}/uic"
      args << "--with-rcc=#{qt5.opt_bin}/rcc"
      args << "--with-mkvtoolnix-gui"
      args << "--enable-qt"
    end

    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<-EOS.undent
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
