# frozen_string_literal: true

# Generated from automation/templates/kbpulse.rb. Edit the template, not this file.
cask "kbpulse" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/KBPulse/releases/download/v#{version}/KBPulse-#{version}-#{arch}.dmg"
  name "KBPulse"
  desc "Pulse the keyboard backlight"
  homepage "https://github.com/wiggly-sheets/KBPulse"

  depends_on macos: :sonoma

  app "KBPulse.app"

  zap trash: [
    "~/Library/Application Support/KBPulse",
    "~/Library/Preferences/com.ethanrdoesmc.kbpulseapp.plist",
  ]

  caveats <<~EOS
    KBPulse is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, Control-click the app in Finder and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "#{appdir}/KBPulse.app"

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
