require 'formula'

class Xrootd < Formula
  homepage 'http://xrootd.slac.stanford.edu/dload.html'
  url 'http://xrootd.slac.stanford.edu/download/v3.1.1/xrootd-3.1.1.tar.gz'
  md5 '6466b12a99aed3f8ea0b56b5b3ace093'

  depends_on 'cmake' => :build

  def install
    Dir.mkdir "build"
    Dir.chdir "build" do
        system "cmake #{std_cmake_parameters} .."
        system "make install"
    end
  end

  def test
    system "xrootd"
  end
end
