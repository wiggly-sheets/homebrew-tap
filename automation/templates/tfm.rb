# This is the tap's tfm formula — the copy in the tap is generated from automation/templates/tfm.rb, so change the template.
# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"

  url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/vVERSION_PLACEHOLDER/tfm-universal-macos.gz"
  sha256 "SHA256_PLACEHOLDER"
  head "https://github.com/wiggly-sheets/tfm-tui-mac"

  depends_on macos: :ventura

  def install
    bin.install "tfm-universal-macos" => "tfm"
  end

  test do
    system "#{bin}/tfm", "--version"
  end
end
