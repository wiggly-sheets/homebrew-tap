# Generated from automation/templates/menutitle.rb. Edit the template, not this file.
cask "menutitle" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.7"
  sha256 arm:   "fa2f938bcecf484abae85e5be9e18f331e76e24b679cf1f07986c982ed425a25",
         intel: "94d208fc133afabbe5c61fee9b2cfa4ac436d2d7a675f697404bd5f9deff5138"

  url "https://github.com/wiggly-sheets/menutitle/releases/download/v#{version}/MenuTitle-#{version}-#{arch}.dmg"
  name "MenuTitle"
  desc "Show the focused window title in the menu bar"
  homepage "https://github.com/wiggly-sheets/menutitle"

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
