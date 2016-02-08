class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20160122.tar.gz"
  sha256 "ac5de1d74fdbe88604b34949f3949e53cb72e55e148e46b8c2be98806c888a10"

  depends_on :gpg

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
    system "git", "init"
    system "#{bin}/blackbox_initialize", "yes"
  end
end
