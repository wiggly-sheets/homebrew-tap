# Release contract

Every product repository of this estate builds and releases the same way, so the daily job of the tap can pick up any release without a special case per product. This document is that rule. It is the only shared artefact of the estate: there is no Makefile that is fetched over the network, and every product repository implements the contract in its own Makefile.

The tap side of the contract lives in this repository. The asset names and the checksum file of every product are recorded in `automation/products.json`, and the daily job reads them from there.

## What the tap does with a release

The daily job reads the latest stable release of each upstream repository, checks the digest that GitHub reports against the checksum file that the release publishes, renders the template of the product, lints the result and pushes the new tap file to `main`. The job knows no product by hand. The contract is what makes that possible, because every release arrives in the same shape.

Nothing in a product repository writes into the tap, and nothing in the tap reaches into a product repository. The two sides meet at the release.

## Targets

Every product repository offers the targets below. A call of `make` without a target runs `help`. A product without an application bundle does not offer the targets that need one.

| Target | What it does | Products |
|---|---|---|
| `help` | Prints the list of the targets. It is the default goal. | All |
| `build` | Builds the project in the configuration used for development. | All |
| `test` | Runs the changelog check and the test suite. | All |
| `verify` | Checks the built artifact offline: architecture, version, signature, and any product-specific content. | All |
| `run` | Builds the launchable artifact, installs it and launches it. | All |
| `install` | Builds and copies the artifact into `$(HOME)/Applications`; tfm installs its binary with `install.sh`. | All |
| `app` | Builds the application bundle of the product. | Every product with a bundle |
| `app-arm` | Builds the application bundle for arm64. | fluor, spacemap |
| `app-intel` | Builds the application bundle for x86_64. | fluor, spacemap |
| `app-universal` | Builds the application bundle for arm64 and x86_64. | fluor, spacemap, SketchyBar Studio |
| `dmg` | Builds the disk image of the product. | Every product with a bundle |
| `dmg-arm` | Builds the disk image for arm64. | fluor, spacemap |
| `dmg-intel` | Builds the disk image for x86_64. | fluor, spacemap |
| `dmg-universal` | Builds the disk image for arm64 and x86_64. | fluor, spacemap, SketchyBar Studio |
| `release-artifacts` | Builds every file that the release publishes and verifies its checksum. | All |
| `release-notes VERSION=x.y.z` | Prints the changelog section of a version. | All |
| `release VERSION=x.y.z` | Bumps the changelog and version files, tests, builds, verifies, commits and creates the tag. | All |
| `clean` | Removes the build output. | All |

The targets of a product repository are the interface of the estate. A person, or an agent that works in that repository, needs to know one list of names and nothing else.

## The development loop

`make run` is the same outcome in every product: the launchable artifact is
built, installed into `$(HOME)/Applications`, and launched. `make install` does
the same without launching. A product may override `INSTALL_DIR` on the command
line, but the default is the user Applications folder, so no target needs
`sudo` and a local build never replaces a Homebrew install.

The app may treat `/Applications` and `~/Applications` alike. The Homebrew cask
installs into `/Applications`; a local `make run` installs into
`~/Applications`. spaces-renamer and spacemap accept both paths, so a local run
is not treated as a staging build.

`make verify` never builds. It checks the artifact that is already on disk,
which is why the release workflow can run it after `make release-artifacts` and
CI can run it after `make app`. The checks are offline and product-specific:
architecture slices, the recorded SDK where the product uses Liquid Glass, the
bundle version against `VERSION`, localizations, embedded helpers, the tweak
registry, and the ad-hoc signature.

`make test` runs `scripts/changelog.sh check` before the product's own suite, so
a malformed changelog fails the same gate as a failing test.

## Architectures

A product offers a per-architecture target only when it can build that architecture. The universal target counts as a per-architecture target, because a universal binary holds two architectures. A product that ships one architecture only, such as an Apple silicon only product, offers no per-architecture target at all, and the plain `app` and `dmg` targets build that one artifact.

| Product | Architectures it builds | Per-architecture targets | Note |
|---|---|---|---|
| fluor | arm64, x86_64, universal | `app-arm`, `app-intel`, `app-universal`, `dmg-arm`, `dmg-intel`, `dmg-universal` | `make app` builds the universal bundle, and the release ships that one |
| spacemap | arm64, x86_64, universal | `app-arm`, `app-intel`, `app-universal`, `dmg-arm`, `dmg-intel`, `dmg-universal` | The release ships a disk image per architecture |
| SketchyBar Studio | universal | `app-universal`, `dmg-universal` | One universal package |
| SwiftDefaults | arm64 | None | Apple silicon only |
| Leader Key | arm64 | None | Apple silicon only |
| Wallpaper Selector | arm64 | None | Apple silicon only |
| Spaces Renamer | arm64 | None | Apple silicon only |
| tfm | universal | None | A command line tool without an application bundle |

## The changelog

Every product keeps a `CHANGELOG.md` in the shape of [Keep a
Changelog](https://keepachangelog.com/en/1.1.0/):

```
## [Unreleased]

### Added
- ...

## [1.2.3] - 2026-11-12

### Added / Changed / Deprecated / Removed / Fixed / Security
- ...
```

The rules are:

- Exactly one `[Unreleased]` section, first in the file.
- A released heading is exactly `## [X.Y.Z] - YYYY-MM-DD`. A prerelease adds a
  suffix: `## [X.Y.Z-rc.1] - YYYY-MM-DD`.
- Versions are in descending order, with no duplicates and no empty released
  section.
- The category headings are only `Added`, `Changed`, `Deprecated`, `Removed`,
  `Fixed` and `Security`, in that order, at most once per version.
- No `---` separators, no bare `## date` headings and no hand-written
  Full Changelog links.
- A changelog that predates the shape may keep its old history below a single
  `<!-- pre-versioning -->` line. The checker validates everything above that
  line; new releases are added above it and are checked.
- Entries are bullets. A release needs at least one entry.

The canonical script is `scripts/changelog.sh`, copied verbatim into every
repository. It has three modes:

| Mode | Behavior |
|---|---|
| `check` | Validates the shape. `make test` runs it. |
| `bump X.Y.Z` | Moves the whole `[Unreleased]` body under `## [X.Y.Z] - <UTC date>` and opens a fresh `[Unreleased]`. It refuses an empty Unreleased or an existing version. |
| `notes X.Y.Z` | Prints the section body without the heading. It exits 3 when the section is missing or empty. |

The release notes are the `notes` body. The product title, the download and
install instructions and the checksums belong in the release body generated by
the workflow, not in the changelog.

## The rules of a release

1. A release is cut by pushing a tag `vX.Y.Z` on the default branch. Nothing else starts a release.
2. The tag is the only source of the version. The build stamps it into the bundle, and the release fails when the bundle reports a different version.
3. `make test` runs on every push and every pull request, and again inside the release workflow before the build. It checks the changelog shape first; a failing check or test blocks the release.
4. The release publishes the asset plus a checksum file that sits next to it. The checksum file holds one line per asset: the digest, two spaces, the bare file name.
5. The name of the checksum file is the name of the asset with `.sha256` added. Two products use `checksums.txt` instead: fluor and spacemap. The name is fixed per product, and the tap reads it from `automation/products.json`.
6. The tag must sit on the default branch.
7. The release notes come from the section of the project's own CHANGELOG for that version, extracted with `scripts/changelog.sh notes`. A stable version with no section, or with an empty section, fails the release. The workflow appends a `## Checksums` block generated from the sidecar.
8. Signing is ad-hoc everywhere: identity `-`, no certificate, no team identifier, no notarization. Notarization is allowed only where a product already holds the secrets, and it never replaces the ad-hoc floor.
9. Nothing writes into the tap. The daily job of the tap follows the release.

## The version

The version is three numbers, `x.y.z`. The tag carries a leading `v`, so the tag `v1.2.3` holds the version `1.2.3`. The tap replaces `{version}` in an asset pattern with the version of the release, without the leading `v`.

A prerelease carries a suffix after the third number. The daily job ignores a prerelease, because it reads the release that GitHub reports as the latest one.

The version in the bundle comes from the tag and from nowhere else. A build that stamps another version, or a bundle that reports another version, fails the release.

## `make release VERSION=x.y.z`

The release target prepares a release and stops there. It never pushes anything.

- The version comes from the command line.
- It refuses a dirty working tree, a version whose tag already exists and a
  `HEAD` that is not on the default branch.
- It runs `scripts/changelog.sh bump`, which moves `[Unreleased]` to the
  released version. It refuses an empty `[Unreleased]`, so a release always has
  notes.
- It updates the product's version files where they exist: `package.json` for
  tfm; `VERSION`, `Sources/spacemap/Info.plist` and the regenerated
  `spacemap.xcodeproj` for spacemap. The changelog is the only file it updates
  for the other products.
- It runs `make test`, `make release-artifacts VERSION=…` and
  `make verify VERSION=…`.
- It commits the bump as `chore(release): vX.Y.Z`, then creates the annotated
  tag `vX.Y.Z`.
- If a step before the commit fails, it restores the bumped files, so a stopped
  release leaves no half-bump.
- It prints the commands that push the commit and the tag.

The person who runs it decides when to push. The push is the release.

## `make release-artifacts`

This target produces the disk image and every file that the tap expects next to it. The names of the produced files must not change, because the tap matches the assets by name.

The authoritative list of the names per product lives in the tap, in `automation/products.json`, in the pattern of the asset and in the name of the sidecar. The names in use today are:

| Product | Asset | Checksum file |
|---|---|---|
| fluor | `Fluor.dmg` | `checksums.txt` |
| SketchyBar Studio | `SketchyBarStudio-<version>-universal.dmg` | `SketchyBarStudio-<version>-universal.dmg.sha256` |
| spacemap | `spacemap-<version>-arm64.dmg` and `spacemap-<version>-x86_64.dmg` | `checksums.txt` |
| Spaces Renamer | `SpacesRenamer-v<version>.dmg` | `SpacesRenamer-v<version>.dmg.sha256` |
| SwiftDefaults | `SwiftDefaults-<version>.dmg` | `SwiftDefaults-<version>.dmg.sha256` |
| Leader Key | `LeaderKey-<version>.dmg` | `LeaderKey-<version>.dmg.sha256` |
| Wallpaper Selector | `WallpaperSelector-<version>.dmg` | `WallpaperSelector-<version>.dmg.sha256` |
| tfm | `tfm-universal-macos.gz` | `tfm-universal-macos.gz.sha256` |

A release that changes the name of an asset needs a change of the pattern in `automation/products.json` first. Otherwise the daily job reports that the release does not hold the file, and it leaves the file of the product in the tap alone.

The checksum file holds one line per asset, in the format of `shasum -a 256`:

```
522894d5b8c0b7bfddc584b7e03a114f9e7bb74876c6c0cb7f4943aa8289f850  Fluor.dmg
```

`release-artifacts` verifies the checksum it just wrote with `shasum -a 256 -c`,
so a wrongly named line fails the local target and not only the release.

## The release workflow

The workflow of a product repository runs when the tag is pushed. It never runs
on `workflow_dispatch`, because a release starts with a pushed tag. It does the
following.

1. It checks out the repository and resolves the version from the tag.
2. It fetches the default branch and asserts that the tag sits on it.
3. It runs `make test`, which checks the changelog shape and the suite. A
   failure stops the release.
4. It runs `make release-artifacts VERSION=…` and `make verify VERSION=…`.
5. It writes the body with `scripts/changelog.sh notes VERSION` and appends a
   `## Checksums` block generated from the sidecar.
6. It publishes the release with the exact assets, the sidecar, the title
   `<Product> <version>`, and `prerelease: true` when the tag carries a suffix.
   `fail_on_unmatched_files` is on, so a missing asset fails the publish.

The workflow never writes into the tap and never touches another repository.

## Checking a repository against the contract

- `make help` lists the targets of the repository, and the list holds every target of the table above that the product offers.
- `make test` runs the changelog check and the suite, and it fails when either fails.
- `make app` then `make verify` checks the artifact that CI will ship.
- `make run` installs the app into `~/Applications` and launches it.
- `make release-artifacts VERSION=1.2.3` builds the assets, verifies the checksum, and the produced files carry the names of the table above.
- `make release-notes VERSION=1.2.3` prints the changelog section, and it fails when the section is missing or empty.
- The names of the produced files and the line of the checksum file are the two things that the tap matches.

The tap checks the same facts from the outside. Its dry run reports the digest of every asset, says whether the checksum file agrees with it and names the products it skipped.

## Deviations

- tfm has no `app` and no `dmg`. It is a command line tool, so it has no application bundle and no disk image. It publishes the universal binary only, and `make install` uses its own `install.sh`.
- SketchyBar Studio has no `app-arm` and no `app-intel`, and no `dmg-arm` and no `dmg-intel`. It ships one universal package, so a per-architecture build would produce an artifact that nobody installs.
- SwiftDefaults, Wallpaper Selector and Spaces Renamer have no per-architecture target. They are Apple silicon only, so the plain `app` and `dmg` targets build the only artifact they ship.
- Leader Key is an imported Xcode project. It publishes the same tag, asset and checksum shape, but it does not yet implement the Makefile targets of this contract.
- spacemap releases a stable `x.y.z` only. The Xcode project stores the version as its build version, which is numeric, so the release target rejects a prerelease suffix.
- KBPulse follows the development loop, offers the release targets and runs a tag-triggered release workflow, but it is a fork of an upstream repository and is not published through the tap yet.
