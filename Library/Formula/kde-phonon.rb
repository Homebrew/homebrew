require 'formula'

class KdePhonon < Formula
<<<<<<< HEAD
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.6.0/src/phonon-4.6.0.tar.xz'
  homepage 'http://phonon.kde.org/'
  md5 'bbe0c1c62ed14c31479c4c1a6cf1e173'
=======
  homepage 'http://phonon.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.5.0/src/phonon-4.5.0.tar.bz2'
  md5 '32f8d388c18fde2e23dea7bb103f9713'
>>>>>>> 0e8ea8aae9dadda53d0dc0cf680d383981770be9

  depends_on 'xz' => :build
  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'qt'
  depends_on 'glib' => :build

  keg_only "This package is already supplied by Qt and is only needed by KDE packages."

  def install
    inreplace 'cmake/FindPhononInternal.cmake',
        'BAD_ALLOCATOR AND NOT WIN32', 'BAD_ALLOCATOR AND NOT APPLE'
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
