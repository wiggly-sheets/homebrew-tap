# Generated from automation/templates/spacemap.rb. Edit the template, not this file.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "22ba73720a1d4d57b8695e8c855a51f503e1a82f93d03f1caf5035e39eb1b2a2",
         intel: "10fc7a3a60abf16e45285db39d8985c95cb8414a5b3f5465c32c056fb8a55db5"

  url "https://github.com/wiggly-sheets/Spacemap/releases/download/v#{version}/spacemap-#{version}-#{arch}.dmg"
  name "Spacemap"
  desc "Visualize spaces as an interactive map"
  homepage "https://github.com/wiggly-sheets/Spacemap"

  depends_on macos: :ventura

  app "Spacemap.app"

  zap trash: [
    "~/.config/spacemap",
    "~/Library/Preferences/com.zm.spacemap.plist",
  ]

  caveats <<~EOS
    Spacemap is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine /Applications/Spacemap.app

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
