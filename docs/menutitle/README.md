# MenuTitle

MenuTitle ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask menutitle
```

## What is MenuTitle?

A native menu bar window title. MenuTitle reads the focused window from yabai and shows its title after the front app's menus.

## Requirements

- macOS 14 or later
- yabai running with window titles queryable
- Accessibility access for MenuTitle
- Apple Silicon (arm64) only

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/menutitle.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask menutitle
```

## Uninstalling

```bash
brew uninstall --cask menutitle
```

## Project

- App repository: https://github.com/wiggly-sheets/menutitle
- Releases: https://github.com/wiggly-sheets/menutitle/releases
