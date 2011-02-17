require 'formula'

class Libgtextutils <Formula
  url 'http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-0.6.tar.bz2'
  homepage 'http://hannonlab.cshl.edu/fastx_toolkit/'
  md5 'd6969aa0d31cc934e1fedf3fe3d0dc63'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
