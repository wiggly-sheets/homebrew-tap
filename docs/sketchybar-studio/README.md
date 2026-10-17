# Homebrew Tap for SketchyBar Studio

Install SketchyBar Studio from this custom Homebrew tap.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask sketchybar-studio
```

Or install directly:

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask wiggly-sheets/homebrew-tap/sketchybar-studio
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

## Project

- App repository: https://github.com/wiggly-sheets/SketchyBar-Studio
- Releases: https://github.com/wiggly-sheets/SketchyBar-Studio/releases
