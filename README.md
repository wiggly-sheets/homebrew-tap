# Homebrew Tap for wiggly-sheets

Custom Homebrew tap for wiggly-sheets macOS utilities.

## Casks and Formulas

| Name | Type | Description |
|------|------|-------------|
| `wallpaper-selector` | cask | Native menu-bar wallpaper picker and rotator |
| `spacesrenamer` | cask | Give Spaces persistent names in Mission Control |
| `sketchybar-studio` | cask | Preview and edit SketchyBar configs in real time |
| `spacemap` | cask | Visualize spaces as an interactive map |
| `fluor` | cask | Make your function keys fit the app you're using |
| `swiftdefaults` | cask | GUI for managing defaults |
| `tfm` | formula | Mouse-first terminal file manager |

## Where the tap files come from

Every cask and the formula in this tap are generated output. The tap renders them from the templates in `automation/templates/` and follows the latest stable release of each upstream repository, so a new release reaches the tap without a manual step.

The rules for the tap live in [AGENTS.md](AGENTS.md). The mechanics of the generator live in [automation/README.md](automation/README.md).

## Install

Tap the repository and trust it:

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
```

Then install any cask or formula:

```bash
brew install --cask wallpaper-selector
brew install --cask spacesrenamer
brew install --cask sketchybar-studio
brew install --cask spacemap
brew install --cask fluor
brew install --cask swiftdefaults
brew install tfm
```

## Individual Product Docs

- [wallpaper-selector](docs/wallpaper-selector/README.md)
- [spacesrenamer](docs/spacesrenamer/README.md)
- [sketchybar-studio](docs/sketchybar-studio/README.md)
- [spacemap](docs/spacemap/README.md)
- [fluor](docs/fluor/README.md)
- [swiftdefaults](docs/swiftdefaults/README.md)
- [tfm-tui-mac](docs/tfm-tui-mac/README.md)

## Project Repositories

- [wallpaper-selector](https://github.com/wiggly-sheets/wallpaper-selector)
- [spaces-renamer](https://github.com/wiggly-sheets/spaces-renamer)
- [SketchyBar-Studio](https://github.com/wiggly-sheets/SketchyBar-Studio)
- [Spacemap](https://github.com/wiggly-sheets/Spacemap)
- [Fluor](https://github.com/wiggly-sheets/fluor)
- [SwiftDefaults](https://github.com/wiggly-sheets/swiftdefaults)
- [tfm-tui-mac](https://github.com/wiggly-sheets/tfm-tui-mac)