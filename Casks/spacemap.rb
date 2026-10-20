# The tap's spacemap cask comes from automation/templates/spacemap.rb. Edit the template to change it.
cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.1"
  sha256 arm:   "79bd8e41fca67c35dbc395b47882bed1ea52e11806519dcf620fe42ceb4060aa",
         intel: "c2cd0d79e69e06bffc3c7a0ac15e29c2a05e367f4946c9ea401e1436ad443590"

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
