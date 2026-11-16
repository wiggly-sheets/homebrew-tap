# Generated from automation/templates/menutitle.rb. Edit the template, not this file.
cask "menutitle" do
  version "1.1.1"
  sha256 "596742017937a289ddbb0263a6648d6c835677b0c8fc9e4fe084eb5286d45b3f"

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
