require "formula"

class Trr < Formula
  homepage "https://code.google.com/p/trr22/"
  url "https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz"
  sha1 "17082cc5fcebb8c877e6a17f87800fecc3940f24"
  version "22"

  depends_on "nkf"
  depends_on "apel"

  def install
    system "make", "clean"
    system "sed -i -e \"s,TRRDIR = \\\/usr\\\/local\\\/trr,TRRDIR = \\\/usr\\\/local\\\/Cellar\\\/trr\\\/22\\\/lib,\" Makefile"
    system "sed -i -e \"s,INFODIR = \\\/usr\\\/local\\\/info,INFODIR = \\\/usr\\\/local\\\/Cellar\\\/trr\\\/22\\\/lib,\" Makefile"
    system "cp /usr/local/share/emacs/site-lisp/apel/* ."
    system "cp /usr/local/share/emacs/site-lisp/emu/* ."
    system "mv /usr/local/share/emacs/site-lisp/apel/* /usr/local/share/emacs/site-lisp/"
    system "rmdir /usr/local/share/emacs/site-lisp/apel"
    system "mv /usr/local/share/emacs/site-lisp/emu/* /usr/local/share/emacs/site-lisp/"
    system "rmdir /usr/local/share/emacs/site-lisp/emu"
    system "make", "all"
    system "make", "install"
    system "nkf -w --overwrite /usr/local/Cellar/trr/22/lib/CONTENTS"
    system "touch /usr/local/Cellar/trr/22/lib/record/SCORES-IC"
  end

  def caveats
      msg = <<-EOF.undent
      Add below to your emacs configuration file. (ex. ~/emacs.d/init.el)

        (add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
        (autoload 'trr "/usr/local/share/emacs/site-lisp/trr" nil t)

      By doing \"M-x trr\" in emacs, you can start trr
      EOF
  end

end
