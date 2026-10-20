# Wallpaper Selector

Wallpaper Selector ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask wallpaper-selector
```

## What is Wallpaper Selector?

A native macOS menu-bar wallpaper picker and rotator.

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/wallpaper-selector.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask wallpaper-selector
```

## Uninstalling

```bash
brew uninstall --cask wallpaper-selector
brew untap wiggly-sheets/homebrew-tap
```

## Project

- App repository: https://github.com/wiggly-sheets/wallpaper-selector
- Releases: https://github.com/wiggly-sheets/wallpaper-selector/releases