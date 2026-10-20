# fluor

fluor ships as a cask in the `wiggly-sheets/homebrew-tap` tap, the one tap that holds every wiggly-sheets product.

## Install

```bash
brew tap wiggly-sheets/homebrew-tap
brew trust wiggly-sheets/homebrew-tap
brew install --cask fluor
```

## What is fluor?

Fluor keeps the top row of your keyboard in the mode that makes sense for the app in front of you. Use media controls everywhere, use F1–F12 everywhere, or let Fluor choose on an app-by-app basis.

## Features

- **Two keyboard modes** — switch between media-key behavior and standard function keys.
- **Per-app rules** — give an app its own behavior, while unconfigured apps follow your default.
- **A clear menu bar indicator** — see the active mode at a glance and change it from the menu.
- **Configurable global shortcut** — toggle modes from any app. The default shortcut is ⌃⌥⌘F, and it can be replaced or cleared in **Settings → General**.
- **Flexible triggering** — switch by active window, the Fn key, or a hybrid of both.
- **Lightweight controls** — configure launch at login, notifications, menu-bar appearance, and whether the menu-bar item is shown.

## macOS 26

Fluor targets macOS 26 and later. It uses the current macOS keyboard preference and asks the system to apply mode changes; the legacy `IOHIDSystem` write path has been removed. Launch at login uses Apple's native `SMAppService` API.

The configurable global shortcut requires **Accessibility** permission. Open **Settings → Advanced**, select **Grant Access…**, enable Fluor in System Settings, then return to Fluor. Permission is not required when you only use window-based switching.

## Uninstalling

```bash
brew uninstall --cask fluor
brew untap wiggly-sheets/homebrew-tap
```

## How the tap stays current

The tap renders this cask from its own template, `automation/templates/fluor.rb`, and follows the latest stable release of the upstream repository. A new upstream release reaches the tap without any manual step.

The rules for the tap live in `AGENTS.md`. The mechanics of the generator live in `automation/README.md`.

## Updating

When a new version is released, upgrade the app:

```bash
brew upgrade --cask fluor
```

## Project Repository

- [Fluor on GitHub](https://github.com/wiggly-sheets/fluor)