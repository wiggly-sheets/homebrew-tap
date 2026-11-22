# Generated from automation/templates/spacemap.rb. Edit the template, not this file.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "2.2.2"
  sha256 arm:   "63ec2d9da53aaec6ff1c1cc469bbea38c42a314e5c6fb46db5c357d07c5dedb4",
         intel: "6c29841331feb3f5ffc832a34f7434c0b1770fab3d144d175d0ef80c43637024"

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
