cask "swiftdefaults" do
  version "1.0.0"
  sha256 "PLACEHOLDER"

  url "https://github.com/wiggly-sheets/swiftdefaults/releases/download/v#{version}/SwiftDefaults-#{version}.dmg"
  name "SwiftDefaults"
  desc "Tweak macOS without touching Terminal — browse and toggle system defaults"
  homepage "https://github.com/wiggly-sheets/swiftdefaults"

  depends_on macos: :sequoia

  app "SwiftDefaults.app"

  zap trash: [
    "~/Library/Application Support/SwiftDefaults",
    "~/Library/Preferences/com.wigglysheets.SwiftDefaults.plist",
  ]
end