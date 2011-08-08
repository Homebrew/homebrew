require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  url 'http://netpbm.svn.sourceforge.net/svnroot/netpbm/trunk', :revision => 1529
  version 'r1529'

  depends_on "libtiff"
  depends_on "jasper"

  def install
    ENV.x11 # For PNG

    system "cp", "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{HOMEBREW_PREFIX}/include/jasper"
    end

    ENV.deparallelize
    system "make"

    stage_dir = Pathname(Dir.pwd) + 'stage'
    system "make", "package", "pkgdir=#{stage_dir}"

    Dir.chdir stage_dir do
      prefix.install %w{ bin include lib misc }
      share.install Dir['man']
      lib.install Dir['link/*.a']
    end
  end
end
