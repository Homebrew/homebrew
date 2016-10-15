class WirouterKeyrec < Formula
  homepage "http://www.salvatorefresta.net/tools/"
  url "http://tools.salvatorefresta.net/WiRouter_KeyRec_1.1.2.zip"
  version "1.1.2"
  sha1 "3c17f2d0bf3d6201409862fd903ebfd60c1e8a2e"

  def install
  	inreplace "src/agpf.h", /\/etc/, "#{prefix}/etc"
	inreplace "src/teletu.h", /\/etc/, "#{prefix}/etc"
	
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make prefix=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}", "BIN_DIR=bin/"
    
  end

  test do
    
    system "#{bin}/wirouterkeyrec -s Alice-123456"
  end
end
