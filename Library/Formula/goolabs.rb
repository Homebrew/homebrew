
class Goolabs < Formula
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://pypi.python.org/packages/source/g/goolabs/goolabs-0.1.1.tar.gz"
  sha1 "3201102ab0fad77d57a09dd7c879f6f163e05799"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.8.0.tar.gz"
    sha1 "aa3b0659cbc85c6c7a91efc51f2d1007040070cd"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-3.3.tar.gz"
    sha1 "d716a932b930d71059e49465b6b42e833808369a"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha1 "f906c441be2f0e7a834cbf701a72788d3ac3d144"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    res = %w[six click requests]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/goolabs", "morph", "test") do |stdin, stdout, stderr, _|
        assert_equal "Usage: goolabs morph [OPTIONS] [SENTENCE]\n\nError: Missing option \"--app-id\" / \"-a\" or GOOLABS_APP_ID enviroment value.\n", stderr.read
    end
  end
end
