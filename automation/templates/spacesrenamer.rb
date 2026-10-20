# frozen_string_literal: true

# The tap's spacesrenamer cask comes from automation/templates/spacesrenamer.rb. Edit the template to change it.
# Homebrew formula for Spaces Renamer
#
# Install from the consolidated tap:
#   brew tap wiggly-sheets/homebrew-tap
#   brew install --cask spacesrenamer
#
# Or directly from the raw cask URL:
#   brew install --cask wiggly-sheets/homebrew-tap/spacesrenamer.rb
#
# This formula installs the .app bundle to /Applications.
# The Dock injection bundle is bundled inside the app.

cask "spacesrenamer" do
  version "VERSION_PLACEHOLDER"
  sha256 "SHA256_PLACEHOLDER"

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
    "~/Library/Containers/com.alexbeals.spacesrenamer",
  ]
end
