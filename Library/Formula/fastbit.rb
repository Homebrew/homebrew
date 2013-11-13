require 'formula'

class Fastbit < Formula
  homepage 'https://sdm.lbl.gov/fastbit/'
  url 'https://codeforge.lbl.gov/frs/download.php/409/fastbit-ibis1.3.8.tar.gz'
  sha1 '3e0feed7932d34be49ca41fdb689f55b0466a28a'

  conflicts_with 'salt', :because => 'both install `include/filter.h`'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/fastbit-config", "--version"
  end
end
