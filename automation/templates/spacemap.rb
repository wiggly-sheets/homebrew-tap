# frozen_string_literal: true

# The tap's spacemap cask comes from automation/templates/spacemap.rb. Edit the template to change it.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/Spacemap/releases/download/v#{version}/spacemap-#{version}-#{arch}.dmg"
  name "Spacemap"
  desc "Visualize spaces as an interactive map"
  homepage "https://github.com/wiggly-sheets/Spacemap"

  depends_on macos: :ventura

  app "Spacemap.app"

  zap trash: [
    "~/.config/spacemap",
    "~/Library/Preferences/com.spacemap.plist",
  ]
end
