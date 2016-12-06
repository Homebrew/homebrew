class Blackbox < Formula
  homepage "http://the-cloud-book.com/"
  url "https://github.com/StackExchange/blackbox/archive/v1.20150730.tar.gz"
  desc "Safely store secrets in Git/Mercurial/Subversion"
  sha256 "a28237e8839d000273d0fe0ba8f9701cab66a3b942787c5c8e8d329912564ae4"

  depends_on "gpg"

  def install
    bin.install "bin/_blackbox_common.sh"
    bin.install "bin/_blackbox_common_test.sh"
    bin.install "bin/_stack_lib.sh"
    bin.install "bin/blackbox_addadmin"
    bin.install "bin/blackbox_cat"
    bin.install "bin/blackbox_decrypt_all_files"
    bin.install "bin/blackbox_deregister_file"
    bin.install "bin/blackbox_diff"
    bin.install "bin/blackbox_edit"
    bin.install "bin/blackbox_edit_end"
    bin.install "bin/blackbox_edit_start"
    bin.install "bin/blackbox_initialize"
    bin.install "bin/blackbox_list_files"
    bin.install "bin/blackbox_postdeploy"
    bin.install "bin/blackbox_recurse"
    bin.install "bin/blackbox_register_new_file"
    bin.install "bin/blackbox_removeadmin"
    bin.install "bin/blackbox_shred_all_files"
    bin.install "bin/blackbox_update_all_files"
    bin.install "bin/blackbox_whatsnew"
  end

  test do
    system "/usr/local/Cellar/yourformula/version/bin/git", "init"
    system "#{bin}/blackbox_initialize", "yes"
  end
end
