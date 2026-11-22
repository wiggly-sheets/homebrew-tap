# air-battery

air-battery ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask air-battery
```

## What is air-battery?

A fork of AirBattery that shows battery levels for your Mac, iPhone, iPad, Bluetooth devices and nearby devices in the menu bar, Dock and widgets. This build adds menu bar time remaining, a time-to-full estimate, a percentage-only style, a Liquid Glass dropdown on macOS 26 and later, and a working Low Power Mode toggle.

## Requirements

- macOS 14 or later
- Bluetooth permission for Bluetooth battery levels
- Local Network permission for Nearcast transfers

## Low Power Mode rule

The optional Low Power Mode toggle runs `pmset` as root. After the first approval it installs a narrow rule at `/etc/sudoers.d/airbattery` so later toggles do not ask for a password. The rule permits only `/usr/bin/pmset -a lowpowermode 0` and `1`. Remove it with:

```bash
sudo rm /etc/sudoers.d/airbattery
```

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/air-battery.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

```bash
brew upgrade --cask air-battery
```

## Uninstalling

```bash
brew uninstall --cask air-battery
brew untap wiggly-sheets/homebrew-tap
```

## Project

- App repository: https://github.com/wiggly-sheets/Air-Battery
- Releases: https://github.com/wiggly-sheets/Air-Battery/releases
