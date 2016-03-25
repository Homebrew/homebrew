class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "http://www.ferzkopp.net/joomla/content/view/19/14/"
  url "https://downloads.sourceforge.net/projects/sdlgfx/files/SDL_gfx-2.0.25.tar.gz"
  sha256 "556eedc06b6cf29eb495b6d27f2dcc51bf909ad82389ba2fa7bdc4dec89059c0"

  bottle do
    cellar :any
    revision 1
    sha256 "202f917c2ceef69a4ec07de2a9a61e8def2c9d8499cc15633c5efbb3c4db914c" => :el_capitan
    sha256 "5ddb753e99634dc89b304ed949057302c79338380cce9362d13d467e632dd583" => :yosemite
    sha256 "48b831afc3d4b1deda9a91694777af630ae8a522c62df5e31cf7dcc366dfde2b" => :mavericks
    sha256 "5b6a20c88f9ab960c2efe940770a9a8771e7f537d78b151b5e0cd82fa1474733" => :mountain_lion
  end

  depends_on "sdl"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
