require 'formula'

class VoAmrwbenc < Formula
  url 'http://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/vo-amrwbenc-0.1.1.tar.gz'
  homepage 'http://sourceforge.net/projects/opencore-amr/'
  md5 'ce55df38265c4e3140e42b74dd91e44c'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
