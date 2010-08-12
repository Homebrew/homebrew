require 'formula'

class GitExtras <Formula
  url 'git://github.com/visionmedia/git-extras.git', :tag => '0.0.1'
  version '0.0.1'
  head 'git://github.com/visionmedia/git-extras.git', :branch => 'master'

  homepage 'http://github.com/visionmedia/git-extras'

  def install
    system "make", "prefix=#{prefix}", "install"
  end
end
