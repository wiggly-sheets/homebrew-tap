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
- SIP disabled, or reduced so filesystem, debugging, and NVRAM protections are off (only changeable from Recovery)
- The `-arm64e_preview_abi` boot argument (the app can add it via an administrator prompt)
- MIP injection and the boot-argument write ask for administrator authorization; DYLD activation is unprivileged

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

If you used the MIP backend, remove its runtime in **Settings** before `brew uninstall`, because `brew uninstall` does not remove the privileged runtime or the LaunchDaemons it registers.

```bash
brew uninstall --cask spacesrenamer
brew untap wiggly-sheets/homebrew-tap
```

The published Dock and WindowManager preference keys can optionally be cleared:

```bash
defaults delete com.apple.dock SpacesRenamerNames
defaults delete com.apple.dock SpacesRenamerMonitors
defaults delete com.apple.WindowManager SpacesRenamerPlugin   # or com.apple.dock on macOS 26 and earlier
```

If a name still shows, restart the host with `killall WindowManager` (macOS 27+) or `killall Dock`.

## Project

- App repository: https://github.com/wiggly-sheets/spaces-renamer
- Releases: https://github.com/wiggly-sheets/spaces-renamer/releases
