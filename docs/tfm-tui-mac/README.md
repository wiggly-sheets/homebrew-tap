# tfm

tfm ships as a formula in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install tfm
```

> **Note:** tfm is a CLI tool, not a GUI app. It is distributed as a Homebrew **formula**, not a cask.

## What is tfm-tui-mac?

tfm is a mouse-first terminal file manager built with OpenTUI. It runs inside your terminal and lets you navigate, select, and launch files with a mouse — no modal keybindings to memorize.

## Features

- **Mouse-first** — click to navigate, select, and open files
- **Terminal-native** — runs inside your existing terminal with no separate window
- **Cross-platform** — Linux (x64, arm64), macOS (arm64, x64, universal)
- **Plugin system** — extend with custom plugins
- **Self-update** — `tfm --update` to get the latest version

## Requirements

- macOS 12 or later (Monterey+)
- Linux with glibc (x64 or arm64)
- Bun 1.4.0+ for development

## Uninstalling

```bash
brew uninstall tfm
brew untap wiggly-sheets/homebrew-tap
```

## How the tap stays current

The tap renders this formula from its own template, `automation/templates/tfm.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade tfm
```

## Project Repository

- [tfm-tui-mac on GitHub](https://github.com/wiggly-sheets/tfm-tui-mac)