# Generated from automation/templates/spacemap.rb. Edit the template, not this file.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "2.2.0"
  sha256 arm:   "b617331b2dd156bdccb6502354c34041d4c7230e7d944f1d550d84209f3cf08d",
         intel: "7386a028e69fe359f053c808c4fb59955e07df4eb7b1fdbc1b2632a35fb55e7e"

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
