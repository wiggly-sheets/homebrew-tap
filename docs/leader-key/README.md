# Leader Key

Leader Key ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every
wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask leader-key
```

## What is Leader Key?

A keyboard shortcut launcher with nested leader-key sequences. This is the independent Wiggly Sheets
fork, not the upstream project.

Fork additions include hyper key display as `✦`, command clipboard placeholders, named action deep
links, text snippet actions, cheatsheet search, fuzzy search, and Liquid Glass tint colors.

## Requirements

- macOS 14.4 or later
- Separate Apple Silicon (arm64) and Intel (x86_64) builds
- Accessibility access for text snippet actions

## Configuration

Leader Key stores its configuration at:

```text
~/Library/Application Support/Leader Key/config.json
```

If you selected a custom configuration directory in Settings, use that directory instead.

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/leader-key.rb`, and follows
the latest stable release of the upstream repository. A new release reaches the tap without any
manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in
`automation/README.md`.

## Updating

```bash
brew upgrade --cask leader-key
```

## Uninstalling

```bash
brew uninstall --cask leader-key
```

## Project

- App repository: https://github.com/wiggly-sheets/LeaderKey
- Releases: https://github.com/wiggly-sheets/LeaderKey/releases
