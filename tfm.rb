# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"
  version "1.0.0"
  sha256 "fbe3a910ebc472411acfe3d5d4d4a31c8dc194f32a1db357dc04bf60d6820a85"

  url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v1.0.0/tfm-universal-macos.gz"
  head "https://github.com/wiggly-sheets/tfm-tui-mac"

  depends_on macos: :ventura

  def install
    bin.install "tfm-universal-macos" => "tfm"
  end

  test do
    system "#{bin}/tfm", "--version"
  end
end