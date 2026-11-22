# Homebrew Tap for wiggly-sheets

Custom Homebrew tap for wiggly-sheets macOS utilities.

## Casks and Formulas

| Name | Type | Latest | Description |
|------|------|--------|-------------|
| `wallpaper-selector` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/wallpaper-selector?sort=semver&label=release)](https://github.com/wiggly-sheets/wallpaper-selector/releases) | Native menu-bar wallpaper picker and rotator |
| `spacesrenamer` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/spaces-renamer?sort=semver&label=release)](https://github.com/wiggly-sheets/spaces-renamer/releases) | Give Spaces persistent names in Mission Control |
| `sketchybar-studio` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/SketchyBar-Studio?sort=semver&label=release)](https://github.com/wiggly-sheets/SketchyBar-Studio/releases) | Preview and edit SketchyBar configs in real time |
| `spacemap` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/Spacemap?sort=semver&label=release)](https://github.com/wiggly-sheets/Spacemap/releases) | Visualize spaces as an interactive map |
| `fluor` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/fluor?sort=semver&label=release)](https://github.com/wiggly-sheets/fluor/releases) | Make your function keys fit the app you're using |
| `swiftdefaults` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/swiftdefaults?sort=semver&label=release)](https://github.com/wiggly-sheets/swiftdefaults/releases) | GUI for managing defaults |
| `tfm` | formula | [![release](https://img.shields.io/github/v/release/wiggly-sheets/tfm-tui-mac?sort=semver&label=release)](https://github.com/wiggly-sheets/tfm-tui-mac/releases) | Mouse-first terminal file manager |
| `menutitle` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/menutitle?sort=semver&label=release)](https://github.com/wiggly-sheets/menutitle/releases) | Show the focused window title in the menu bar |
| `air-battery` | cask | [![release](https://img.shields.io/github/v/release/wiggly-sheets/Air-Battery?sort=semver&label=release)](https://github.com/wiggly-sheets/Air-Battery/releases) | Show battery levels of all devices in the menu bar, Dock and widgets |

## Where the tap files come from

Every cask and the formula in this tap are generated output. The tap renders them from the templates in `automation/templates/` and follows the latest stable release of each upstream repository, so a new release reaches the tap without a manual step.

The rules for the tap live in [AGENTS.md](AGENTS.md). The mechanics of the generator live in [automation/README.md](automation/README.md). The contract that the upstream product repositories follow lives in [docs/release-contract.md](docs/release-contract.md).

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
brew install --cask menutitle
brew install --cask air-battery
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
- [menutitle](docs/menutitle/README.md)
- [air-battery](docs/air-battery/README.md)

## Project Repositories

- [wallpaper-selector](https://github.com/wiggly-sheets/wallpaper-selector)
- [spaces-renamer](https://github.com/wiggly-sheets/spaces-renamer)
- [SketchyBar-Studio](https://github.com/wiggly-sheets/SketchyBar-Studio)
- [Spacemap](https://github.com/wiggly-sheets/Spacemap)
- [Fluor](https://github.com/wiggly-sheets/fluor)
- [SwiftDefaults](https://github.com/wiggly-sheets/swiftdefaults)
- [tfm-tui-mac](https://github.com/wiggly-sheets/tfm-tui-mac)
- [menutitle](https://github.com/wiggly-sheets/menutitle)
- [Air-Battery](https://github.com/wiggly-sheets/Air-Battery)
