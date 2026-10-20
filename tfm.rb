# The tap's tfm formula comes from automation/templates/tfm.rb. Edit the template to change it.
# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"

  url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v1.0.0/tfm-universal-macos.gz"
  sha256 "9f8302503ea03360dba0b28cf409c4993ae0e5fc5670b6780320d23cba0e307e"
  head "https://github.com/wiggly-sheets/tfm-tui-mac"

  depends_on macos: :ventura

  def install
    bin.install "tfm-universal-macos" => "tfm"
  end

  test do
    system "#{bin}/tfm", "--version"
  end
end
