# Generated from automation/templates/menutitle.rb. Edit the template, not this file.
cask "menutitle" do
  version "1.1.6"
  sha256 "bade4e0f5abad6e91e77d30e3af1b790b719618277dbb27f2a0646ff0d6df68b"

  url "https://github.com/wiggly-sheets/menutitle/releases/download/v#{version}/MenuTitle-#{version}.dmg"
  name "MenuTitle"
  desc "Show the focused window title in the menu bar"
  homepage "https://github.com/wiggly-sheets/menutitle"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "MenuTitle.app"

  zap trash: "~/Library/Preferences/com.wigglysheets.menutitle.plist"

  caveats <<~EOS
    MenuTitle uses Accessibility access to read window titles and measure the menu bar. Grant it in System Settings > Privacy & Security > Accessibility.

    MenuTitle is ad-hoc signed and not notarized. macOS may block the first launch or ask for Accessibility again after an update. If macOS blocks the app, open it through System Settings > Privacy & Security or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "#{appdir}/MenuTitle.app"

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
