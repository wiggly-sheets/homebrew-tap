# frozen_string_literal: true

# Generated from automation/templates/air-battery.rb. Edit the template, not this file.
cask "air-battery" do
  arch = on_arch_conditional arm: "arm64", intel: "x86_64"

  version "VERSION_PLACEHOLDER"
  sha256 arm:   "SHA256_ARM_PLACEHOLDER",
         intel: "SHA256_INTEL_PLACEHOLDER"

  url "https://github.com/wiggly-sheets/Air-Battery/releases/download/v#{version}/AirBattery-#{version}-#{arch}.dmg"
  name "AirBattery"
  desc "Show battery levels of all devices in the menu bar, Dock and widgets"
  homepage "https://github.com/wiggly-sheets/Air-Battery"

  depends_on macos: :sonoma

  app "AirBattery.app"

  zap trash: [
    "~/Library/Containers/com.callieskye.AirBattery.widget",
    "~/Library/Preferences/com.callie.skye.AirBatteryHelper.plist",
    "~/Library/Preferences/com.callieskye.AirBattery.plist",
    "~/Library/Preferences/com.callieskye.AirBattery.widget.plist",
  ]

  caveats <<~EOS
    AirBattery is ad-hoc signed and not notarized. macOS may block the first launch. If that happens, open it through System Settings > Privacy & Security, right-click the app and choose Open, or remove the quarantine attribute manually:

      xattr -dr com.apple.quarantine "#{appdir}/AirBattery.app"

    Only run the quarantine command for apps you downloaded from a source you trust.

    The optional no-password Low Power Mode toggle writes /etc/sudoers.d/airbattery. Remove that rule with:

      sudo rm /etc/sudoers.d/airbattery
  EOS
end
