class Remind < Formula
  homepage "http://www.roaringpenguin.com/products/remind"
  url "http://www.roaringpenguin.com/files/download/remind-03.01.13.tar.gz"
  sha1 "dce46b2334b3849255feffe6cba4973f3c883647"

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    reminders = "reminders"
    (testpath/reminders).write "ONCE 2015-01-01 Homebrew Test"
    assert_equal "Reminders for Thursday, 1st January, 2015:\n\nHomebrew Test\n\n", shell_output("#{bin}/remind #{reminders} 2015-01-01")
  end
end
