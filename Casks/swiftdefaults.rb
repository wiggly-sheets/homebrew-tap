# The tap's swiftdefaults cask comes from automation/templates/swiftdefaults.rb. Edit the template to change it.
cask "swiftdefaults" do
  version "1.0.1"
  sha256 "8767d7b06040c464e64d0205b3ca6fdd34778f20cee97ec8c42ee36dd40884b0"

  url "https://github.com/wiggly-sheets/swiftdefaults/releases/download/v#{version}/SwiftDefaults-#{version}.dmg"
  name "SwiftDefaults"
  desc "GUI for managing defaults"
  homepage "https://github.com/wiggly-sheets/swiftdefaults"

  depends_on macos: :sequoia

  app "SwiftDefaults.app"

  zap trash: [
    "~/Library/Application Support/SwiftDefaults",
    "~/Library/Preferences/com.wigglysheets.SwiftDefaults.plist",
  ]

  caveats <<~EOS
    SwiftDefaults is not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine /Applications/SwiftDefaults.app

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
