class B2Tools < Formula
  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://github.com/Backblaze/B2_Command_Line_Tool/archive/v0.3.12.tar.gz"
  sha256 "6c382d211c5df09477d5df468e43fe5b9691e44edfb5df9694e9b747a488d362"

  def install
    bin.install "b2"
  end

  test do
    system "b2 authorize_account BOGUSACCTID BOGUSAPPKEY | grep bad_auth_token"
  end
end

