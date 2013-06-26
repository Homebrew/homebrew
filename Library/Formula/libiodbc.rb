require 'formula'

class Libiodbc < Formula
  homepage 'http://www.iodbc.org/dataspace/iodbc/wiki/iODBC/'
  url 'http://sourceforge.net/projects/iodbc/files/iodbc/3.52.8/libiodbc-3.52.8.tar.gz'
  sha1 '93a3f061afff3152c5fcee1e5af8b802760a7e74'

  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build

  def install
    # run bootstrap.sh
    system "sh",  "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install" 
  end

  test do
    system "#{bin}/iodbc-config", "--version"
  end
end
