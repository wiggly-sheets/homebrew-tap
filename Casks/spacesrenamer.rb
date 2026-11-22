# Generated from automation/templates/spacesrenamer.rb. Edit the template, not this file.
# Homebrew cask for Spaces Renamer
#
# Install from the consolidated tap:
#   brew tap wiggly-sheets/homebrew-tap
#   brew install --cask spacesrenamer
#
# Or without tapping first:
#   brew install --cask wiggly-sheets/homebrew-tap/spacesrenamer
#
# This cask installs the .app bundle to /Applications.
# The Dock injection bundle is bundled inside the app.

cask "spacesrenamer" do
  version "2.0.0"
  sha256 "a17d12de11cefffb0364710814d2ed6bc6e805518669b54914092acf8c08e995"

  url "https://github.com/wiggly-sheets/spaces-renamer/releases/download/v#{version}/SpacesRenamer-v#{version}.dmg"
  name "Spaces Renamer"
  desc "Give Spaces persistent names in Mission Control"
  homepage "https://github.com/wiggly-sheets/spaces-renamer"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "SpacesRenamer.app"

  zap trash: [
    "~/.config/spacesrenamer",
    "~/Library/Application Support/SpacesRenamer",
    "~/Library/Preferences/com.wiggly-sheets.SpacesRenamer.plist",
  ]

  caveats <<~EOS
    Spaces Renamer is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine /Applications/SpacesRenamer.app

    Only run the quarantine command for apps you downloaded from a source you trust.

    Names inside Mission Control need Apple Silicon, reduced macOS security, and the -arm64e_preview_abi boot argument. See https://github.com/wiggly-sheets/spaces-renamer#security-and-compatibility for the security and compatibility steps.

    Deactivate injection before uninstalling. If you used the MIP backend, brew uninstall does not remove its privileged runtime or LaunchDaemons.
  EOS
end
