cask "spacemap" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.1"
  sha256 arm:   "79bd8e41fca67c35dbc395b47882bed1e099012d71594a213a98e4453c816a5b",
         intel: "e31c32226f3f88a87084675a0f0b11137c8233f55f9f48907421578b586461d7"

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
