require 'formula'

class Xlsperl < Formula
  url 'http://perl.jonallen.info/attachment/30/XLSperl-0.7.tar.gz'
  homepage 'http://perl.jonallen.info/projects/xlsperl'
  md5 '833006c8667b19d9759d988aafb09e4f'

  depends_on 'Spreadsheet::ParseExcel' => :perl
  depends_on 'Spreadsheet::WriteExcel' => :perl
  depends_on 'Variable::Alias' => :perl

  def install
    system "perl Makefile.PL"
    system "make"
    bin.install ['blib/script/XLSperl']
    man.install Dir['blib/man1']
    man.install Dir['blib/man3']
  end
end


