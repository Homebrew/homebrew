require 'formula'

class Lsyncd < Formula
  homepage 'https://github.com/axkibe/lsyncd'
  url 'https://github.com/axkibe/lsyncd/archive/release-2.1.5.tar.gz'
  sha1 '2b8eb169365edc54488a97435bbd39ae4a6731b8'

  depends_on 'asciidoc'   => :build
  depends_on 'automake'   => :build
  depends_on 'docbook'    => :build
  depends_on 'pkg-config' => :build
  depends_on 'lua'

  resource 'xnu' do
    # Note: Do not use MacOS::version -- the version number is not
    # enough, we need the patch number as well.
    osx_version = `sw_vers -productVersion`.strip
    case osx_version
      when "10.7.5"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-1699.32.7.tar.gz'
        sha1 'da3df48952b40ad3b8612c7f639b8bf0f92fb414'
      when "10.8"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.7.9.tar.gz'
        sha1 '9aaf1e0b0a148ff303577161fecaf3ea6188aa1b'
      when "10.8.1"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.9.2.tar.gz'
        sha1 '2bd58959afc5ac8f2c9fa3d693882acc96b25321'
      when "10.8.2"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.18.24.tar.gz'
        sha1 '3a2a0b3629cb215b17aca3bb365b8b10b8b408fe'
      when "10.8.3"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.22.13.tar.gz'
        sha1 'a002806d1e64505c6a98c10af26186454818a9ff'
      when "10.8.4"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.24.15.tar.gz'
        sha1 'a080f28b7385b0cc63f9ba5a07d922d53ea0a4a3'
      when "10.8.5"
        url 'http://www.opensource.apple.com/tarballs/xnu/xnu-2050.48.11.tar.gz'
        sha1 '1f6860148f8231a53a6b393aa1af589cdedfc70c'
      when "10.9"
        url "http://www.opensource.apple.com/tarballs/xnu/xnu-2422.1.72.tar.gz"
        sha1 "c7bdc40396df3c51ece934c0e3b4a19b063ea34c"
    else
      # If raised, go to http://www.opensource.apple.com/ and find the XNU
      # version used by your version of OSX.
      raise Homebrew::InstallationError.new(
        self, "No XNU version known for OSX " + osx_version
      )
    end
  end

  def install
    # XNU Headers
    system "tar", "xf", resource('xnu').fetch
    xnu_path = Dir['xnu*'][0]
    ENV.append 'CPPFLAGS', "-I./#{xnu_path}"

    # Docbook Catalog
    docbook = Formula.factory('docbook')
    ENV.append 'XML_CATALOG_FILES', docbook.opt_prefix/'docbook/xml/4.5/catalog.xml'

    # Asciidoc Binary
    a2x = Formula.factory('asciidoc')
    a2x_path = a2x.bin/'a2x'

    system "autoreconf", "--install"
    system "./configure", "--disable-dependency-tracking",
                          "--with-fsevents", "--without-inotify",
                          "--prefix=#{prefix}"

    # For an unknown reason, A2X is not defined in the makefile,
    # and doc compilation will fail if we do not add it.
    system "sed", "-i.bu", "399 i\\\nA2X = #{a2x_path}\n", "Makefile"
    system "make"
    system "make install"

  end

  def test
    system "lsyncd", "--version"
  end
end
