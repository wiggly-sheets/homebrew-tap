# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"

  on_macos do
    on_arm:   url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v1.0.0/tfm-aarch64-macos.gz"
    on_intel: url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v1.0.0/tfm-x86_64-macos.gz"
  end

  depends_on macos: :monterey

  def install
    # Homebrew auto-decompresses .gz; the resulting binary is arch-specific.
    # Rename it to the canonical `tfm` name in bin/.
    binary_name = if Hardware::CPU.arm?
      "tfm-aarch64-macos"
    else
      "tfm-x86_64-macos"
    end
    bin.install binary_name => "tfm"
  end

  test do
    system "#{bin}/tfm", "--help"
  end
end
