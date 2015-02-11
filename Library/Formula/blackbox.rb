class Blackbox < Formula
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20150203.tar.gz"
  version "1.20150203"
  sha1 "dbe69ab20924ecc5c02ad917a52a57ec1f01addd"

  patch do
    url "https://gist.githubusercontent.com/ekristen/84875c88ffd502f190cc/raw/770221fb0cefea9212fc987a08fad2bfe181c110/homebrew.patch"
    sha1 "c507a4ba7daccd755e6505c34cdb241087bc0143"
  end

  def install
    chmod 0755, Dir["bin/*"]
    libexec.install Dir['*']
    
    bin.install_symlink "#{libexec}/bin/blackbox_addadmin"
    bin.install_symlink "#{libexec}/bin/blackbox_cat"
    bin.install_symlink "#{libexec}/bin/blackbox_edit"
    bin.install_symlink "#{libexec}/bin/blackbox_edit_end"
    bin.install_symlink "#{libexec}/bin/blackbox_edit_start"
    bin.install_symlink "#{libexec}/bin/blackbox_initialize"
    bin.install_symlink "#{libexec}/bin/blackbox_postdeploy"
    bin.install_symlink "#{libexec}/bin/blackbox_register_new_file"
    bin.install_symlink "#{libexec}/bin/blackbox_removeadmin"
    bin.install_symlink "#{libexec}/bin/blackbox_shred_all_files"
    bin.install_symlink "#{libexec}/bin/blackbox_update_all_files"
    bin.install_symlink "#{libexec}/bin/blackbox_addadmin"
  end
end
