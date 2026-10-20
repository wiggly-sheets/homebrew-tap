# spacemap

spacemap ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask spacemap
```

## What is spacemap?

A macOS utility that visualizes yabai workspaces in a floating 2D grid overlay.

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/spacemap.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask spacemap
```

## Uninstalling

```bash
brew uninstall --cask spacemap
brew untap wiggly-sheets/homebrew-tap
```

## Project

- App repository: https://github.com/wiggly-sheets/Spacemap
- Releases: https://github.com/wiggly-sheets/Spacemap/releases
