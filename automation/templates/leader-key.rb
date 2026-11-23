# frozen_string_literal: true

# Generated from automation/templates/leader-key.rb. Edit the template, not this file.
cask "leader-key" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/LeaderKey/releases/download/v#{version}/LeaderKey-#{version}-#{arch}.dmg"
  name "Leader Key"
  desc "Keyboard shortcut launcher with nested leader-key sequences"
  homepage "https://github.com/wiggly-sheets/LeaderKey"

  depends_on macos: :sonoma

  app "Leader Key.app"

  zap trash: [
    "~/Library/Application Support/Leader Key",
    "~/Library/Preferences/com.wigglysheets.LeaderKey.plist",
  ]

  caveats <<~EOS
    Leader Key is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "/Applications/Leader Key.app"

    Only run the quarantine command for apps you downloaded from a source you trust.

    Leader Key may ask for Accessibility access to send synthetic text for text actions. Grant it in System Settings > Privacy & Security > Accessibility.
  EOS
end
