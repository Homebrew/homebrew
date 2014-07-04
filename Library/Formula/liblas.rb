require 'formula'

class Liblas < Formula
  homepage 'http://liblas.org'
  url 'http://download.osgeo.org/liblas/libLAS-1.7.0.tar.gz'
  sha1 'f31070efdf7bb7d6675c23c6c6c84584e3a10869'

  head 'https://github.com/libLAS/libLAS.git'

  depends_on 'cmake' => :build
  depends_on 'libgeotiff'
  depends_on 'gdal'
  depends_on 'boost'
  depends_on 'laszip' => :optional

  option 'with-test', 'Verify during install with `make test`'

  # Fix for error of conflicting types for '_GTIFcalloc' between gdal 1.11 and libgeotiff
  # https://github.com/libLAS/libLAS/issues/33 (committed, remove on next stable release)
  patch do
    url "https://github.com/libLAS/libLAS/commit/b8799e.diff"
    sha1 "3d2430327f9bbff9bd1f6d7cba80c7837552204e"
  end

  def install
    mkdir 'macbuild' do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   http://liblas.org/compilation.html
      ENV['Boost_INCLUDE_DIR'] = "#{HOMEBREW_PREFIX}/include"
      ENV['Boost_LIBRARY_DIRS'] = "#{HOMEBREW_PREFIX}/lib"
      args = ["-DWITH_GEOTIFF=ON", "-DWITH_GDAL=ON"] + std_cmake_args
      args << "-DWITH_LASZIP=ON" if build.with? 'laszip'
      system "cmake", "..", *args
      system "make"
      system "make test" if build.with? "test"
      system "make install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end
