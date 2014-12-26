class Vavrdiasm < Formula
  homepage "https://github.com/vsergeev/vAVRdisasm"
  url "https://github.com/vsergeev/vavrdisasm/archive/v3.1.tar.gz"
  sha1 "8ac78c7ec26760ac76e25a1ff399cfc255b2bc52"

  # Patch:
  # - BSD `install(1)' does not have a GNU-compatible `-D' (create intermediate
  #   directories) flag. Switch to using `mkdir -p'.
  # - Make `PREFIX' overridable
  #   https://github.com/vsergeev/vavrdisasm/pull/2
  patch :DATA

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 3b61942..f1c94fc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 PROGNAME = vavrdisasm
-PREFIX = /usr
+PREFIX ?= /usr
 BINDIR = $(PREFIX)/bin
 
 ################################################################################
@@ -35,7 +35,8 @@ test: $(PROGNAME)
 	python2 crazy_test.py
 
 install: $(PROGNAME)
-	install -D -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)
+	mkdir -p $(DESTDIR)$(BINDIR)
+	install -s -m 0755 $(PROGNAME) $(DESTDIR)$(BINDIR)/$(PROGNAME)
 
 uninstall:
 	rm -f $(DESTDIR)$(BINDIR)/$(PROGNAME)
