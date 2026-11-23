# Generated from automation/templates/swiftdefaults.rb. Edit the template, not this file.
cask "swiftdefaults" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.1"
  sha256 arm:   "a414743cb804b4f2c5348f648737c5fc653209ec3b9aa697ad2af7488a0c48b4",
         intel: "03a33ba1d97b6b004b460fd815501526544daec50ff3120ef64cd7a9381deb18"

  url "https://github.com/wiggly-sheets/swiftdefaults/releases/download/v#{version}/SwiftDefaults-#{version}-#{arch}.dmg"
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
