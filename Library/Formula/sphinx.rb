require 'formula'

class Sphinx < Formula
  homepage 'http://www.sphinxsearch.com'
  url 'http://sphinxsearch.com/files/sphinx-2.2.5-release.tar.gz'
  sha1 '27e1a37fdeff12b866b33d3bb5602894af10bb5e'

  head 'http://sphinxsearch.googlecode.com/svn/trunk/'

  bottle do
    revision 1
    sha1 "d7020be4054ff20240bfc1110b4ccea2d7c52b91" => :yosemite
    sha1 "6ef63f9e2a9f1824e6f1684037c67e9f3bb21cd6" => :mavericks
    sha1 "e4cf1ab52fa67d26cd31a3c428a185f3fcaa7f16" => :mountain_lion
  end

  option 'mysql', 'Force compiling against MySQL'
  option 'pgsql', 'Force compiling against PostgreSQL'
  option 'id64',  'Force compiling with 64-bit ID support'

  depends_on "re2" => :optional
  depends_on :mysql if build.include? 'mysql'
  depends_on :postgresql if build.include? 'pgsql'

  # http://snowball.tartarus.org/
  resource 'stemmer' do
    url 'http://snowball.tartarus.org/dist/libstemmer_c.tgz'
    sha1 '1ac6bb16e829e9f3a58f62c27047c26784975aa1'
  end

  fails_with :llvm do
    build 2334
    cause "ld: rel32 out of range in _GetPrivateProfileString from /usr/lib/libodbc.a(SQLGetPrivateProfileString.o)"
  end

  fails_with :clang do
    build 421
    cause "sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'"
  end

  def install
    (buildpath/'libstemmer_c').install resource('stemmer')

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --localstatedir=#{var}
              --with-libstemmer]

    args << "--enable-id64" if build.include? 'id64'
    args << "--with-re2" if build.with? 're2'

    %w{mysql pgsql}.each do |db|
      if build.include? db
        args << "--with-#{db}"
      else
        args << "--without-#{db}"
      end
    end

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    This is not sphinx - the Python Documentation Generator.
    To install sphinx-python: use pip or easy_install,

    Sphinx has been compiled with libstemmer support.

    Sphinx depends on either MySQL or PostreSQL as a datasource.

    You can install these with Homebrew with:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

      brew install postgresql
        For PostgreSQL server.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
    EOS
  end
end
