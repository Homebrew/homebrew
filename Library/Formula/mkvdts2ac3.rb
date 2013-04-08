require 'formula'

class Mkvdts2ac3 < Formula
  homepage 'https://github.com/JakeWharton/mkvdts2ac3'
  url 'https://github.com/JakeWharton/mkvdts2ac3/archive/1.6.0.tar.gz'
  version '1.6.0'
  sha1 'e427eb6875d935dc228c42e99c3cd19c7ceaa322'

  depends_on 'mkvtoolnix'
  depends_on 'ffmpeg'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/mkvdts2ac3.sh" => "mkvdts2ac3"
  end

  def test
    system "#{bin}/mkvdts2ac3", "-V"
  end
end
