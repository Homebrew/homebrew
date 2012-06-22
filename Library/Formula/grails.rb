require 'formula'

class Grails < Formula
  homepage 'http://grails.org'
  url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.0.4.zip'
  sha1 '8a7a0edf83f1890f87bda5ee316e35cc608e2ebd'
  version '2.0.4'
  
  devel do
    url 'http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.1.0.RC3.zip'
    version '2.1.0.RC3'
    sha1 '5af59f6ba3c9363d8a233e97e6b6e70fc5715b3c'
  end

  def install
    rm_f Dir["bin/*.bat", "bin/cygrails", "*.bat"]
    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Notes On Upgrading Grails From Versions < 1.3.7

    The directory layout has been changed slightly for versions >= 1.3.7
    in order to conform with Homebrew conventions for installation of Java
    jar files.  Please note the following:

    Before upgrading:
      run 'brew unlink grails' (keeps old version in cellar)
    or
      run 'brew rm grails' (deletes old version from cellar)

    and then:
      run 'brew prune'

    This is to ensure that HOMEBREW_PREFIX is cleaned of references to the
    old version.

    The Grails home directory for versions < 1.3.7 was in the form:
      #{HOMEBREW_CELLAR}/grails/1.3.6

    For versions >= 1.3.7, the Grails home directory is in the form:
      #{libexec}

    If you set the GRAILS_HOME variable explicitly in your shell environment,
    change its value accordingly.
    EOS
  end
end
