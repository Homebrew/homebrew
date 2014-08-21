require 'formula'

class Onepass < Formula
  homepage 'https://github.com/georgebrock/1pass'
  url 'https://github.com/georgebrock/1pass.git', :using => :git, :tag => "0.2.1"
  sha1 '8dbfa5e062ce08e26c5619dbdb2b27323e5b3dc9'
  head 'https://github.com/georgebrock/1pass.git'

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "swig" => :build

  resource "M2Crypto" do
    url "https://pypi.python.org/packages/source/M/M2Crypto/M2Crypto-0.22.3.tar.gz"
    sha1 "c5e39d928aff7a47e6d82624210a7a31b8220a50"
  end

  resource "fuzzywuzzy" do
    url "https://pypi.python.org/packages/source/f/fuzzywuzzy/fuzzywuzzy-0.2.tar.gz"
    sha1 "ef080ced775dee1669150ebe4bd93c69f51af16f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"

    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource("M2Crypto").stage { system "python", *install_args }
    resource("fuzzywuzzy").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "python", "setup.py", "test"
    system "#{bin}/1pass", "-h"
  end
end
