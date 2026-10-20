# SwiftDefaults

SwiftDefaults ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask swiftdefaults
```

## What is SwiftDefaults?

SwiftDefaults is a native Mac utility for browsing and toggling macOS system defaults. It catalogs dozens of settings hidden behind `defaults write` commands, explains each in plain English, and applies them with one toggle.

## Features

- **93 tweaks across 21 categories** — Dock, Finder, Screenshots, Window Manager, Keyboard, and more
- **Human-readable titles** — each tweak has a plain-English description
- **Sidebar navigation** with category counts and search across title, description, key, category, domain and id
- **Staged edits, one Apply** — flip a switch to stage the new value; one Apply writes every staged value via `/usr/bin/defaults`
- **Live state** — each launch reads current values with one `defaults export <domain> -` per domain
- **Revert safety** — the value present at launch is captured; Revert restores it or deletes the key when it did not exist
- **Restart guidance** — rows declaring `appToRestart` show "Takes effect after X relaunches"

## Requirements

- macOS 15.0 or later
- Apple Silicon (arm64)
- Write access to user defaults (no Full Disk Access, no sandbox entitlements beyond default)

## Uninstalling

```bash
brew uninstall --cask swiftdefaults
brew untap wiggly-sheets/homebrew-tap
```

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/swiftdefaults.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask swiftdefaults
```

## Project Repository

- [SwiftDefaults on GitHub](https://github.com/wiggly-sheets/swiftdefaults)