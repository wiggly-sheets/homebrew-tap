# Generated from automation/templates/wallpaper-selector.rb. Edit the template, not this file.
cask "wallpaper-selector" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.1"
  sha256 arm:   "b4748aa889c4c06433d1aba05583006db979b644e2ade9ec0a20953a5dd20c96",
         intel: "97f7993c7e9e99d1cc9488516634b731b58d355057afda229b15d18ca1a2a6b1"

  url "https://github.com/wiggly-sheets/wallpaper-selector/releases/download/v#{version}/WallpaperSelector-#{version}-#{arch}.dmg"
  name "Wallpaper Selector"
  desc "Native menu-bar wallpaper picker and rotator"
  homepage "https://github.com/wiggly-sheets/wallpaper-selector"

  depends_on macos: :ventura

  app "Wallpaper Selector.app"

  zap trash: [
    "~/Library/Application Support/WallpaperSelector",
    "~/Library/Preferences/com.wallpaper-selector.macos.plist",
  ]

  caveats <<~EOS
    Wallpaper Selector is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "/Applications/Wallpaper Selector.app"

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
