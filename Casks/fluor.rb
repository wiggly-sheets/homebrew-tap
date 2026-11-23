# Generated from automation/templates/fluor.rb. Edit the template, not this file.
cask "fluor" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "2.8.1"
  sha256 arm:   "4a7c85f701693fbfe967c9da282ff8d3fc7641d18f591b3fd63c98b636150891",
         intel: "7d7aec570b17a911afa4ae19281654227ce15d1dc883169558e822a4c8b4ea6e"

  url "https://github.com/wiggly-sheets/Fluor/releases/download/v#{version}/Fluor-#{version}-#{arch}.dmg"
  name "Fluor"
  desc "Make your function keys fit the app you're using"
  homepage "https://github.com/wiggly-sheets/fluor"

  depends_on macos: :tahoe

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
