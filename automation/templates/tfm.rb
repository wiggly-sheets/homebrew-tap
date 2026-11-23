# frozen_string_literal: true

# Generated from automation/templates/tfm.rb. Edit the template, not this file.
# rubocop:disable FormulaAudit/Checksum, FormulaAudit/ChecksumCase, Lint/DuplicateMethods
# Homebrew formula for tfm-tui-mac.
#
# tfm is a CLI tool, not a GUI app, so it is a formula rather than a cask.
# Install with: brew install wiggly-sheets/homebrew-tap/tfm

class Tfm < Formula
  desc "Mouse-first terminal file manager"
  homepage "https://github.com/wiggly-sheets/tfm-tui-mac"
  version "VERSION_PLACEHOLDER"

  if Hardware::CPU.arm?
    url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v#{version}/tfm-#{version}-arm64-macos.gz"
    sha256 "SHA256_ARM_PLACEHOLDER"
  else
    url "https://github.com/wiggly-sheets/tfm-tui-mac/releases/download/v#{version}/tfm-#{version}-x86_64-macos.gz"
    sha256 "SHA256_INTEL_PLACEHOLDER"
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
# rubocop:enable FormulaAudit/Checksum, FormulaAudit/ChecksumCase, Lint/DuplicateMethods
