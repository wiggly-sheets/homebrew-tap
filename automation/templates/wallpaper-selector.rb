# Template for the tap's wallpaper-selector cask. Rendered by automation/sync-tap.sh — edit here, never in the tap file.
cask "wallpaper-selector" do
  version "VERSION_PLACEHOLDER"
  sha256 "SHA256_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/wallpaper-selector/releases/download/v#{version}/WallpaperSelector-#{version}.dmg"
  name "Wallpaper Selector"
  desc "Native menu-bar wallpaper picker and rotator"
  homepage "https://github.com/wiggly-sheets/wallpaper-selector"

  depends_on macos: :ventura

  app "Wallpaper Selector.app"

  zap trash: [
    "~/Library/Application Support/WallpaperSelector",
    "~/Library/Preferences/com.wallpaper-selector.macos.plist",
  ]
end
