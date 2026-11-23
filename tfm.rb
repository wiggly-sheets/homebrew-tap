# Generated from automation/templates/tfm.rb. Edit the template, not this file.
# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"
  version "1.1.1"

  if Hardware::CPU.arm?
    url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v#{version}/tfm-#{version}-arm64-macos.gz"
    sha256 "7e43cb7d90551ee25771af67ad9a04b7c8e2fda6d0e3eb6a18c06c5dcc769609"
  else
    url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v#{version}/tfm-#{version}-x86_64-macos.gz"
    sha256 "12ca2bf2ef946310856e4f75fcce3ba1eb9863ec0d716f5d98944e713e83b07c"
  end

  head "https://github.com/wiggly-sheets/tfm-tui-mac"

  depends_on macos: :ventura

  def install
    bin.install Dir["tfm-*macos"].first => "tfm"
  end

  test do
    system "#{bin}/tfm", "--version"
  end
end
