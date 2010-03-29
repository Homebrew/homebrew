require 'formula'

class Ec2AmiTools <Formula
  @homepage='http://developer.amazonwebservices.com/connect/entry.jspa?externalID=368'
  @url='http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.3-45758.zip'
  @md5='b3fd0dd779277ba40f0f234bfa309135'

  def install
    FileUtils.rm Dir['bin/*\.cmd']
    (prefix+bin).install Dir['bin/ec2*']
    prefix.install 'lib'
  end
  def caveats
    return <<-EOS
Before you can utilize the EC2 API tools, you must export several environment
variables to your $SHELL. The easiest way to do this is to add them to your
dotfiles. If you’re running the `bash` shell (the default), you’ll want to add
them to `~/.bash_profile`. If this is the case, run `nano ~/.bash_profile` at
a terminal to edit said file. zsh users will want to edit `~/.zprofile`
instead.

    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home/"
    export EC2_HOME="#{prefix.to_s}/"

However, you’re still not ready to use the tools. You need to download your
X.509 certificate and private key from Amazon Web Services. These files are
available at the following URL:

http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key

You should download two `.pem` files, one starting with `pk-`, and one
starting with `cert-`. You need to put both into a folder in your home
directory, `~/.ec2`, and then add the following to your profile file:

    export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
    export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"

    EOS
  end
end
