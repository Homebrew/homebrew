require 'formula'

class Libsvm < Formula
  homepage 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/'
  url 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-3.12.tar.gz'
  md5 'a1b1083fe69a4ac695da753f4c83ed42'

  def install
    inreplace 'Makefile', '-soname', '-install_name'
    inreplace 'Makefile', 'libsvm.so.$(SHVER)', 'libsvm.$(SHVER).dylib'

    system "make", "CFLAGS=#{ENV.cflags}"
    system "make lib"
    ln_s 'libsvm.2.dylib', 'libsvm.dylib'

    bin.install 'svm-scale', 'svm-train', 'svm-predict'
    lib.install 'libsvm.2.dylib', 'libsvm.dylib'
    include.install 'svm.h'
  end
end
