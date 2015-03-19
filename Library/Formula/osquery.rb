require "formula"

class Osquery < Formula
  homepage "http://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git", :tag => "1.4.4", :revision => "800dc7745e2ee81c645ca3cda7c8ca2f4c535ca4"

  bottle do
    sha1 "ce6f4994b20a231c0f882dfd00697972a3fbf476" => :yosemite
    sha1 "1ce7e6f2240c2d053629aff5db3579d454d6de87" => :mavericks
  end

  # Build currently fails on Mountain Lion:
  # https://github.com/facebook/osquery/issues/409
  # Will welcome PRs to fix this!
  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "gflags" => :build
  depends_on "rocksdb" => :build
  depends_on "thrift" => :build
  depends_on "openssl"

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", buildpath+"third-party/python/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage { system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"}
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    require 'open3'
    Open3.popen3("#{bin}/osqueryi") do |stdin, stdout, _|
      stdin.write(".mode line\nSELECT count(version) as lines FROM osquery_info;")
      stdin.close
      assert_equal "lines = 1\n", stdout.read
    end
  end
end
