# This is the tap's fluor cask — the copy in the tap is generated from automation/templates/fluor.rb, so change the template.
cask "fluor" do
  version "VERSION_PLACEHOLDER"
  sha256 "SHA256_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/Fluor/releases/download/v#{version}/Fluor.dmg"
  name "Fluor"
  desc "Make your function keys fit the app you're using"
  homepage "https://github.com/wiggly-sheets/fluor"

  depends_on macos: :sequoia

  app "Fluor.app"

  zap trash: [
    "~/Library/Application Support/Fluor",
    "~/Library/Preferences/com.zm.fluor.plist",
  ]

  caveats <<~EOS
    Fluor is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, Control-click the app in Finder and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "#{appdir}/Fluor.app"

    Only run the quarantine command for apps you downloaded from a source you trust.
  EOS
end
