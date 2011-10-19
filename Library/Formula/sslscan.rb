require 'formula'

class Sslscan < Formula
  url 'http://sourceforge.net/projects/sslscan/files/sslscan/sslscan%201.8.0/sslscan-1.8.0.tgz'
  homepage 'https://www.titania-security.com/labs/sslscan'
  md5 '7f5fa87019024366691c6b27cb3a81e7'

  def patches
    # Fixes the Makefile to properly build sslscan
    DATA
  end

  def install
    system "make"
    bin.install ["sslscan"]
    man1.install ["sslscan.1"]
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test sslscan`. Remove this comment before submitting
    # your pull request!
    system "sslscan"
  end
end

__END__
diff --git a/Makefile b/Makefile
index a3e1654..b1fbda8 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ BINPATH = /usr/bin/
 MANPATH = /usr/share/man/
 
 all:
-	gcc -lssl -o sslscan $(SRCS) $(LDFLAGS) $(CFLAGS)
+	gcc -lssl -lcrypto -o sslscan $(SRCS) $(LDFLAGS) $(CFLAGS)
 
 install:
 	cp sslscan $(BINPATH)

