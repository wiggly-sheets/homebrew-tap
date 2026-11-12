# Spaces Renamer

Spaces Renamer ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask spacesrenamer
```

## What is Spaces Renamer?

Give macOS Spaces persistent names in Mission Control.

## Requirements

- macOS 14 or later
- Apple Silicon only
- Names inside Mission Control need the `-arm64e_preview_abi` boot argument and reduced macOS security protections, as described in the [upstream README](https://github.com/wiggly-sheets/spaces-renamer#security-and-compatibility)
- Activating injection asks for administrator authorization

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/spacesrenamer.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask spacesrenamer
```

## Uninstalling

Deactivate injection in the app first: choose **Deactivate** in the menu-bar popover or in **Settings → Injection**. Turn off **Launch at login**, then quit the app.

```bash
brew uninstall --cask spacesrenamer
brew untap wiggly-sheets/homebrew-tap
```

`brew uninstall` does not remove the privileged MIP runtime or the LaunchDaemons it registers. If a Space name still shows, the published Dock and WindowManager preference keys can be cleared manually:

```bash
defaults delete com.apple.dock SpacesRenamerNames
defaults delete com.apple.dock SpacesRenamerMonitors
defaults delete com.apple.WindowManager SpacesRenamerPlugin   # or com.apple.dock on macOS 26 and earlier
```

## Project

- App repository: https://github.com/wiggly-sheets/spaces-renamer
- Releases: https://github.com/wiggly-sheets/spaces-renamer/releases
