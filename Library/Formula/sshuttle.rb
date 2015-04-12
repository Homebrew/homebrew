require 'formula'

class Sshuttle < Formula
  homepage 'https://github.com/sshuttle/sshuttle'
  url 'https://github.com/sshuttle/sshuttle/archive/sshuttle-0.71.tar.gz'
  sha256 '62f0f8be5497c2d0098238c54e881ac001cd84fce442c2506ab6d37aa2f698f0'

  head 'https://github.com/sshuttle/sshuttle.git'

  #Pre-Yosemite support dropped in sshuttle 0.7.1
  if MacOS.version < :yosemite
    url 'https://github.com/sshuttle/sshuttle/archive/sshuttle-0.70.tar.gz'
    sha256 'b6fd3468f80db18fb33276881facc59e113745da049d3346b5e604dc55675588'
  end

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    libexec.install Dir['src/*']
    bin.write_exec_script libexec/'sshuttle'
  end
end
