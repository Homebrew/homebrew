require 'formula'

class Snort < Formula
  homepage 'http://www.snort.org'
<<<<<<< HEAD
  url 'http://www.snort.org/dl/snort-current/snort-2.9.3.tar.gz'
  md5 'e128f5d5d14dad335dc0c549c7fe2e98'
=======
  url 'http://www.snort.org/dl/snort-current/snort-2.9.3.1.tar.gz'
  sha1 '25dfea22a988dd1dc09a1716d8ebfcf2b7d61c19'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879

  depends_on 'daq'
  depends_on 'libdnet'
  depends_on 'pcre'

  option 'enable-debug', "Compile Snort with --enable-debug and --enable-debug-msgs"

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-ipv6
              --enable-gre
              --enable-mpls
              --enable-targetbased
              --enable-decoder-preprocessor-rules
              --enable-ppm
              --enable-perfprofiling
              --enable-zlib
              --enable-active-response
              --enable-normalizer
              --enable-reload
              --enable-react
              --enable-flexresp3]

    if build.include? 'enable-debug'
      args << "--enable-debug"
      args << "--enable-debug-msgs"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod 644 /dev/bpf*
    or you could create a startup item to do this for you.
    EOS
  end
end
