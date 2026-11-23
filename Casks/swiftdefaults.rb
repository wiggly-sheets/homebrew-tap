# Generated from automation/templates/swiftdefaults.rb. Edit the template, not this file.
cask "swiftdefaults" do
  version "1.1.0"
  sha256 "af1db3866fbfd903768a1aaa61288c269f3938e155a75072037d6dc526785218"

  url "https://github.com/wiggly-sheets/swiftdefaults/releases/download/v#{version}/SwiftDefaults-#{version}.dmg"
  name "SwiftDefaults"
  desc "GUI for managing defaults"
  homepage "https://github.com/wiggly-sheets/swiftdefaults"

  depends_on arch: :arm64
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
