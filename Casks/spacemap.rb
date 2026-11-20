# Generated from automation/templates/spacemap.rb. Edit the template, not this file.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "2.1.0"
  sha256 arm:   "a1c1f336c1a4dcf0e2747e7b4bc23466cdc9820e6419ffe11bb959caba3aa750",
         intel: "273cad0c37b6aedcd395c177cba97d9ac3305b36e6df86340ab510688bb1f6c4"

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
