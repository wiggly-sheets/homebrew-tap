# Generated from automation/templates/wallpaper-selector.rb. Edit the template, not this file.
cask "wallpaper-selector" do
  version "1.1.0"
  sha256 "e54fa445f3f9085f1e495f920546e20e67114257cc6d94ac2ca29cfe9d1e846e"

  url "https://github.com/wiggly-sheets/wallpaper-selector/releases/download/v#{version}/WallpaperSelector-#{version}.dmg"
  name "Wallpaper Selector"
  desc "Native menu-bar wallpaper picker and rotator"
  homepage "https://github.com/wiggly-sheets/wallpaper-selector"

  depends_on arch: :arm64
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
