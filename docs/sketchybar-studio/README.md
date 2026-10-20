# SketchyBar Studio

SketchyBar Studio ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask sketchybar-studio
```

## Trusting the App on macOS

Homebrew may require trusting this custom tap before installing casks from it:

```bash
brew trust wiggly-sheets/homebrew-tap
```

SketchyBar Studio preview builds are unsigned and not notarized. macOS may block the app after Homebrew installs it.

Try one of these trusted-source options:

- Open it through **System Settings > Privacy & Security** after the first blocked launch.
- Right-click `SketchyBarStudio.app` and choose **Open**.
- Remove the quarantine attribute manually:

```bash
xattr -dr com.apple.quarantine /Applications/SketchyBarStudio.app
```

Only run the quarantine command for apps you downloaded from a source you trust.

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/sketchybar-studio.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask sketchybar-studio
```

## Project

- App repository: https://github.com/wiggly-sheets/SketchyBar-Studio
- Releases: https://github.com/wiggly-sheets/SketchyBar-Studio/releases
