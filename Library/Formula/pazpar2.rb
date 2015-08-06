class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "http://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.11.3.tar.gz"
  sha256 "bee8d3529a129cda7c5281b7e9b50ca5d9a2ed1647f4e7cae7da6b568c00eb7a"

  bottle do
    cellar :any
    sha256 "1ba5b525a809477edb5cbafd2fbcefd9fba29d224ccad06064abbdbcb3d9d1e3" => :yosemite
    sha256 "e7b386c553cd3e1d8b123b88abf9df7288371d4423982bfa333456ba3ef40646" => :mavericks
    sha256 "53d1ad3c4eccfd37b51788d10ad7609541aad20537faec0de168c2272857fe2f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
      <threads number="2"/>
      <server>
        <listen port="8004"/>
      </server>
    </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
