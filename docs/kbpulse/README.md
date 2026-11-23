# KBPulse

KBPulse ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask kbpulse
```

## What is KBPulse?

A menu-bar app that pulses the keyboard backlight on a MacBook. It includes the `kbpulse` command line tool in the app bundle.

## Requirements

- macOS 14 or later
- A Mac with a keyboard backlight
- Apple Silicon (arm64) and Intel (x86_64)

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/kbpulse.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask kbpulse
```

## Uninstalling

```bash
brew uninstall --cask kbpulse
brew untap wiggly-sheets/homebrew-tap
```

## Project

- App repository: https://github.com/wiggly-sheets/KBPulse
- Releases: https://github.com/wiggly-sheets/KBPulse/releases
