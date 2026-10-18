cask "fluor" do
  version "2.7.0"

  url "https://github.com/wiggly-sheets/Fluor/releases/download/v#{version}/Fluor.dmg"
  sha256 "522894d5b8c0b7bfddc584b7e03a114f9e7bb74876c6c0cb7f4943aa8289f850"

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
