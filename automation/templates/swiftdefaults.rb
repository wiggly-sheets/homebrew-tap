# Template for the tap's swiftdefaults cask. Rendered by automation/sync-tap.sh — edit here, never in the tap file.
cask "swiftdefaults" do
  version "VERSION_PLACEHOLDER"
  sha256 "SHA256_PLACEHOLDER"

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
end
