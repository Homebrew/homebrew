require 'formula'

class Libevent1 < Formula
  homepage 'http://libevent.org/'
  url 'https://github.com/downloads/libevent/libevent/libevent-1.4.14b-stable.tar.gz'
  sha1 '4a834364c28ad652ddeb00b5f83872506eede7d4'
end

class Honeyd < Formula
  homepage 'http://honeyd.org/'
  url 'http://www.honeyd.org/uploads/honeyd-1.5c.tar.gz'
  sha1 '342cc53e8d23c84ecb91c7b66c6e93e7ed2a992a'

  depends_on 'libdnet'

  def patches
    # make the setrlimit function work. honeyd is no longer developed so patching upstream won't happen
    DATA
  end

  def install
    libevent1_prefix = libexec + 'libevent1'
    Libevent1.new.brew do
      system './configure', "--prefix=#{libevent1_prefix}"
      system 'make install'
    end

    system './configure', "--prefix=#{prefix}", "--with-libevent=#{libevent1_prefix}"
    system 'make install'
  end
end

__END__
diff --git a/honeyd.c b/honeyd.c
index d6dd8e6..bfff951 100644
--- a/honeyd.c
+++ b/honeyd.c
@@ -450,7 +450,7 @@ honeyd_init(void)
 
 	/* Raising file descriptor limits */
 	rl.rlim_max = RLIM_INFINITY;
-	rl.rlim_cur = RLIM_INFINITY;
+	rl.rlim_cur = OPEN_MAX;
 	if (setrlimit(RLIMIT_NOFILE, &rl) == -1) {
 		/* Linux does not seem to like this */
 		if (getrlimit(RLIMIT_NOFILE, &rl) == -1)
