require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  head 'https://github.com/facebook/watchman.git'
  url 'https://github.com/facebook/watchman/archive/v2.9.3.tar.gz'
  sha1 '6647e36105b18b99b03eb009d13d8decc91e1898'

  depends_on :autoconf
  depends_on :automake
  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To increase file limits add 'kern.maxfiles=10485760' and 'kern.maxfilesperproc=10485760'
    to /etc/sysctl.conf (use 'sysctl -w' to do so immediately).

    See https://github.com/facebook/watchman#max-os-file-descriptor-limits
    EOS
  end
end
