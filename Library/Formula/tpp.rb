require 'formula'

class Tpp < Formula
  homepage 'http://synflood.at/tpp.html'
  url 'http://synflood.at/tpp/tpp-1.3.1.tar.gz'
  sha1 'e99fca1d7819c23d4562e3abdacea7ff82563754'

  depends_on 'figlet' => :optional

  def install
    bin.install "tpp.rb" => "tpp"
    share.install ['contrib', 'examples']
    man1.install ['doc/tpp.1']
    doc.install ['README', 'CHANGES', 'DESIGN', 'COPYING', 'THANKS', 'README.de']
    resource('ncurses-ruby').stage do
      inreplace 'extconf.rb', '$CFLAGS  += " -g"', '$CFLAGS  += " -g -DNCURSES_OPAQUE=0"'
      system "ruby", "extconf.rb"
      system "make"
      system "mkdir", "ncurses-ruby"
      system "mv", "lib/ncurses_sugar.rb", "ncurses-ruby/ncurses_sugar.rb"
      system "mv", "ncurses_bin.bundle", "ncurses-ruby"
      lib.install ['ncurses-ruby']
      share.install 'README' => '#{share}/doc/ncurses-ruby/README'
      share.install 'Changes' => '#{share}/doc/ncurses-ruby/Changes'
      share.install 'VERSION' => '#{share}/doc/ncurses-ruby/VERSION'
      share.install 'TODO' => '#{share}/doc/ncurses-ruby/TODO'
      share.install 'COPYING' => '#{share}/doc/ncurses-ruby/COPYING'
      share.install 'THANKS' => '#{share}/doc/ncurses-ruby/THANKS'
    end
  end

  resource 'ncurses-ruby' do
    url 'http://switch.dl.sourceforge.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2'
    mirror 'http://freefr.dl.sourceforge.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2'
    sha1 'e50018fc906e5048403b277a898117e782e267c4'
  end

  def patches
    DATA
  end

  test do
    assert `"#{bin}"/tpp --version`.chomp == "tpp - text presentation program #{version}"
  end
end

__END__
diff --git a/tpp.rb b/tpp.rb
index 5aeb938..e5d4616 100755
--- a/tpp.rb
+++ b/tpp.rb
@@ -7,7 +7,8 @@ version_number = "1.3.1"
 # ncurses-ruby module fails.
 def load_ncurses
   begin
-    require "ncurses"
+    require File.expand_path('../../lib/ncurses-ruby/ncurses_bin.bundle', __FILE__)
+    require File.expand_path('../../lib/ncurses-ruby/ncurses_sugar.rb', __FILE__)
     include Ncurses
   rescue LoadError
     $stderr.print <<EOF
