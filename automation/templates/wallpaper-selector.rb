# This is the tap's wallpaper-selector cask — the copy in the tap is generated from automation/templates/wallpaper-selector.rb, so change the template.
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
