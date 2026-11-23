# Generated from automation/templates/leader-key.rb. Edit the template, not this file.
cask "leader-key" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.18.2"
  sha256 arm:   "56d1e235bf7ed2af77aa3f06e5fd57b0c10cb581796b2a267e26ef0108b7369b",
         intel: "268ee6fe84d66a48af2de4f36c5884f8ec6281ca17e2e4a607ad8ad366cd0b40"

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
