# The tap's sketchybar-studio cask comes from automation/templates/sketchybar-studio.rb. Edit the template to change it.
cask "sketchybar-studio" do
  version "1.0.1"
  sha256 "5ab3c436afb5fe7f3e55ebf71daabf7024dc1ca0d0d19a9756d870f79f935781"

  url "https://github.com/wiggly-sheets/SketchyBar-Studio/releases/download/v#{version}/SketchyBarStudio-#{version}-universal.dmg"
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
