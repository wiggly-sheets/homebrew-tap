# frozen_string_literal: true

# Generated from automation/templates/swiftdefaults.rb. Edit the template, not this file.
cask "swiftdefaults" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

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
