require 'formula'
class SofiaSip < Formula
  depends_on 'glib'
  depends_on 'gettext'
  homepage 'http://sofia-sip.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sofia-sip/sofia-sip/1.12.11/sofia-sip-1.12.11.tar.gz'
  md5 'f3582c62080eeecd3fa4cd5d4ccb4225'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    #bin: addrinfo    localinfo   sip-date    sip-dig     sip-options stunc
    system "localinfo"
    system "sip-date"
  end
end
