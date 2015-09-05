class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.150803.tar.gz"
  sha256 "f7480c0a70a81a846c8e3cdb7b3fc41fc7e09c210498263abd1607028b0b24c7"

  conflicts_with "mg", :because => "both install `mg`"

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  def install
    mg3aopts=" -DDIRED -DPREFIXREGION -DUSER_MODES -DUSER_MACROS"
    mg3aopts << " -DLANGMODE_C" if build.with?("c-mode")
    mg3aopts << " -DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
    mg3aopts << " -DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    mg3aopts = "-DALL" if build.with?("all")
    mg3aopts << " -DEMACS_QUIT"

    system "make", "CDEFS=#{mg3aopts}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    system "script", "-q", "/dev/null", "mg", "-e", "save-buffers-kill-emacs"
  end
end
