# frozen_string_literal: true

# Generated from automation/templates/wallpaper-selector.rb. Edit the template, not this file.
cask "wallpaper-selector" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

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
