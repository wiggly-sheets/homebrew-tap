# Generated from automation/templates/sketchybar-studio.rb. Edit the template, not this file.
cask "sketchybar-studio" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "1.1.0"
  sha256 arm:   "08b9a7d5697dd9577516d154e06895cc5ceb994720230802bdad8639c080bf55",
         intel: "6a5258fbfbde850563b25a5033377dbe42473e15fd876d2eea0d8a353b13be42"

  url "https://github.com/wiggly-sheets/SketchyBar-Studio/releases/download/v#{version}/SketchyBarStudio-#{version}-#{arch}.dmg"
  name "SketchyBar Studio"
  desc "Preview and edit SketchyBar configs in real time"
  homepage "https://github.com/wiggly-sheets/SketchyBar-Studio"

  depends_on macos: :sonoma

  app "SketchyBarStudio.app"

  zap trash: [
    "~/Library/Application Support/SketchyBarStudio",
    "~/Library/Preferences/app.codex.SketchyBarStudio.plist",
  ]

  caveats <<~EOS
    SketchyBar Studio preview builds are unsigned and not notarized. If macOS blocks the app after install, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "#{appdir}/SketchyBarStudio.app"

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
