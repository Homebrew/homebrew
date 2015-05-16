require "formula"

class Libmarisa < Formula
  homepage "https://code.google.com/p/marisa-trie/"
  url "https://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha1 "fb0ed7d993e84dff32ec456a79bd36a00022629d"

  bottle do
    cellar :any
    revision 1
    sha1 "99eb0cbc6afdfb058a12d944217b5dd0e13ed95d" => :yosemite
    sha1 "0881fd8efe266861d9f60deb6ccd9860419db679" => :mavericks
    sha1 "a9a51d0e5c0ad1ceb8e857493cfce501c208e76d" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <marisa.h>
      int main() {
        marisa::Keyset keyset;
        keyset.push_back("a");
        keyset.push_back("app");
        keyset.push_back("apple");

        marisa::Trie trie;
        trie.build(keyset);

        marisa::Agent agent;
        agent.set_query("apple");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lmarisa", "-o", "test"
    system "./test"
  end
end
