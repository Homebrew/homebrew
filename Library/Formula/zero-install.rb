require 'formula'

class ZeroInstall < Formula
  homepage 'http://0install.net/injector.html'
  url 'https://downloads.sf.net/project/zero-install/0install/2.6.2/0install-2.6.2.tar.bz2'
  sha256 '5755226ef4b32f04723bcbe551f4694ddf78dffbb0f589c3140c2d7056370961'

  head 'https://github.com/0install/0install'

  option 'without-gui', "Build without the gui (requires GTK+)"

  depends_on 'gnupg'
  depends_on 'glib' if build.without? 'gui'
  depends_on 'gtk+' if build.with? 'gui'
  depends_on 'gettext' => :build if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'objective-caml' => :build
  depends_on 'opam' => :build

  def install
    modules = "yojson xmlm ounit react lwt extlib ssl ocurl"
    modules += " lablgtk" if build.with? 'gui'

    ENV.deparallelize # parellel builds fail for some of these libs

    # Required for lablgtk2 to find Quartz X11 libs.
    ENV.append_path 'PKG_CONFIG_PATH', '/opt/X11/lib/pkgconfig' if build.with? 'gui'

    # Set up a temp opam dir for building. Since ocaml statically links against ocaml libs, it won't be needed later.
    # TODO: Use $OPAMCURL to store a cache outside the build directory
    ENV['OPAMCURL'] = "curl"
    ENV['OPAMROOT'] = "opamroot"
    ENV['OPAMYES'] = "1"
    ENV['OPAMVERBOSE'] = "1"
    system "opam init --no-setup"
    system "opam install #{modules}"
    system "opam config exec make"
    system "cd dist && ./install.sh #{prefix}"
  end

  test do
    (testpath/"hello.py").write <<-EOPY.undent
      print('hello world')
    EOPY
    (testpath/"hello.xml").write <<-EOXML.undent
      <?xml version="1.0" ?>
      <interface xmlns="http://zero-install.sourceforge.net/2004/injector/interface">
        <name>Hello</name>
        <summary>minimal demonstration program</summary>

        <implementation id="." version="0.1-pre">
          <command name='run' path='hello.py'>
            <runner interface='http://repo.roscidus.com/python/python'></runner>
          </command>
        </implementation>
      </interface>
    EOXML
    assert_equal 'hello world', `#{bin}/0launch --console hello.xml`
  end
end
