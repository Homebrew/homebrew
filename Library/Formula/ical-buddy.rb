require 'formula'

class IcalBuddy < Formula
  # NOTE: the official tarball doesn't actually contain any source,
  # just a prebuilt i386 binary
  homepage 'http://hasseg.org/icalBuddy/'
  url 'http://hasseg.org/git-public/icalBuddy.git', :tag => 'v1.8.8'

  head 'http://hasseg.org/git-public/icalBuddy.git'

  def install
    args = %W[icalBuddy icalBuddy.1 icalBuddyLocalization.1
      icalBuddyConfig.1 COMPILER=#{ENV.cc}]
    system "make", *args
    bin.install "icalBuddy"
    man1.install Dir["*.1"]
  end
end
