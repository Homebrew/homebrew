require 'formula'

class BaculaFd < Formula
  url 'http://downloads.sourceforge.net/project/bacula/bacula/5.0.3/bacula-5.0.3.tar.gz'
  homepage 'http://www.bacula.org/'
  md5 '9de254ae39cab0587fdb2f5d8d90b03b'

  # Cleaning seems to break things:
  def skip_clean? path
	  true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sbindir=#{bin}",
                          "--with-working-dir=#{prefix}/working",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio", "--disable-readline"
    system "make"
    system "make install"

	# Ensure var/run exists:
	system "mkdir -p #{HOMEBREW_PREFIX}/var/run"
  end

end
