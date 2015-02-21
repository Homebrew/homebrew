class Fsh < Formula
  homepage "http://www.lysator.liu.se/fsh/"
  url "http://www.lysator.liu.se/fsh/fsh-1.2.tar.gz"
  sha1 "c2f1e923076d368fbb5504dcd1d33c74024b0d1b"

  def install
    # FCNTL was deprecated and needs to be changed to fcntl
    inreplace "fshcompat.py", "FCNTL", "fcntl"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "fsh", "-V"
  end
end
