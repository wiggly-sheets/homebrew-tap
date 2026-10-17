# Homebrew tap for SwiftDefaults

Install SwiftDefaults via Homebrew:

```bash
brew tap wiggly-sheets/homebrew-tap
brew install --cask swiftdefaults
```

Or in one step:

```bash
brew install wiggly-sheets/homebrew-tap/swiftdefaults
```

## What is SwiftDefaults?

SwiftDefaults is a native Mac utility for browsing and toggling macOS system defaults. It catalogs dozens of settings hidden behind `defaults write` commands, explains each in plain English, and applies them with one toggle.

## Features

- **96 tweaks across 21 categories** — Dock, Finder, Screenshots, Window Manager, Keyboard, and more
- **Human-readable titles** — each tweak has a plain-English description
- **Sidebar navigation** with category counts and search across title, description, and key
- **One-click toggles** — flip a switch to write the new value via `/usr/bin/defaults`
- **Live state** — each launch reads current values with `defaults read`
- **Revert safety** — first toggle captures the original value; Revert restores it or deletes the key when it did not exist
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

## Updating

When a new version is released, update the tap:

```bash
brew upgrade --cask swiftdefaults
```

## Project Repository

- [SwiftDefaults on GitHub](https://github.com/wiggly-sheets/swiftdefaults)