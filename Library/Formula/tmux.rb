require 'formula'

class Tmux < Formula
  homepage 'http://tmux.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tmux/tmux/tmux-1.9/tmux-1.9a.tar.gz'
  sha1 '815264268e63c6c85fe8784e06a840883fcfc6a2'
  option "with-24-bit", "Add support for 24 bit colors"

  bottle do
    cellar :any
    revision 1
    sha1 "5a5e180e33339671bc8c82ed58c26862da037f30" => :yosemite
    sha1 "6092f92f5cd7eeb6ddf3b555cd4e655c4c85e826" => :mavericks
    sha1 "981c8c199a2ea3df18b6651205b4616459ae1f8c" => :mountain_lion
  end

  head do
    url 'git://git.code.sf.net/p/tmux/tmux-code'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    if build.with? "24-bit"
      patch do 
        url "https://gist.githubusercontent.com/JohnMorales/0579990993f6dec19e83/raw/75b073e85f3d539ed24907f1615d9e0fa3e303f4/tmux-24.diff"
        sha1 "101aa54529adf8aa22216c3f35d55fc837c246e8"
      end
    end
  end

  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", '-lresolv'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"

    bash_completion.install "examples/bash_completion_tmux.sh" => 'tmux'
    (share/'tmux').install "examples"
  end

  def caveats; <<-EOS.undent
    Example configurations have been installed to:
      #{share}/tmux/examples
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
