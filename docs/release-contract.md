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
| `test` | Runs the test suite. | All |
| `app` | Builds the application bundle of the product. | Every product with a bundle |
| `app-arm` | Builds the application bundle for arm64. | fluor, spacemap |
| `app-intel` | Builds the application bundle for x86_64. | fluor, spacemap |
| `app-universal` | Builds the application bundle for arm64 and x86_64. | fluor, spacemap, SketchyBar Studio |
| `dmg` | Builds the disk image of the product. | Every product with a bundle |
| `dmg-arm` | Builds the disk image for arm64. | fluor, spacemap |
| `dmg-intel` | Builds the disk image for x86_64. | fluor, spacemap |
| `dmg-universal` | Builds the disk image for arm64 and x86_64. | fluor, spacemap, SketchyBar Studio |
| `release-artifacts` | Builds every file that the release publishes. | All |
| `release VERSION=x.y.z` | Prepares a release and creates the tag. | All |
| `clean` | Removes the build output. | All |

The targets of a product repository are the interface of the estate. A person, or an agent that works in that repository, needs to know one list of names and nothing else.

## Architectures

A product offers a per-architecture target only when it can build that architecture. The universal target counts as a per-architecture target, because a universal binary holds two architectures. A product that ships one architecture only, such as an Apple silicon only product, offers no per-architecture target at all, and the plain `app` and `dmg` targets build that one artifact.

| Product | Architectures it builds | Per-architecture targets | Note |
|---|---|---|---|
| fluor | arm64, x86_64, universal | `app-arm`, `app-intel`, `app-universal`, `dmg-arm`, `dmg-intel`, `dmg-universal` | `make app` builds the universal bundle, and the release ships that one |
| spacemap | arm64, x86_64, universal | `app-arm`, `app-intel`, `app-universal`, `dmg-arm`, `dmg-intel`, `dmg-universal` | The release ships a disk image per architecture |
| SketchyBar Studio | universal | `app-universal`, `dmg-universal` | One universal package |
| SwiftDefaults | arm64 | None | Apple silicon only |
| Wallpaper Selector | arm64 | None | Apple silicon only |
| Spaces Renamer | arm64 | None | Apple silicon only |
| tfm | universal | None | A command line tool without an application bundle |

## The rules of a release

1. A release is cut by pushing a tag `vX.Y.Z` on the default branch. Nothing else starts a release.
2. The tag is the only source of the version. The build stamps it into the bundle, and the release fails when the bundle reports a different version.
3. The test suite runs on every push and every pull request, and again inside the release workflow before the build. A failing test blocks the release.
4. The release publishes the asset plus a checksum file that sits next to it. The checksum file holds one line per asset: the digest, two spaces, the bare file name.
5. The name of the checksum file is the name of the asset with `.sha256` added. Two products use `checksums.txt` instead: fluor and spacemap. The name is fixed per product, and the tap reads it from `automation/products.json`.
6. The tag must sit on the default branch.
7. The release notes come from the section of the project's own CHANGELOG for that version. A stable version with no section fails the release.
8. Signing is ad-hoc everywhere: identity `-`, no certificate, no team identifier, no notarization. Notarization is allowed only where a product already holds the secrets, and it never replaces the ad-hoc floor.
9. Nothing writes into the tap. The daily job of the tap follows the release.

## The version

The version is three numbers, `x.y.z`. The tag carries a leading `v`, so the tag `v1.2.3` holds the version `1.2.3`. The tap replaces `{version}` in an asset pattern with the version of the release, without the leading `v`.

A prerelease carries a suffix after the third number. The daily job ignores a prerelease, because it reads the release that GitHub reports as the latest one.

The version in the bundle comes from the tag and from nowhere else. A build that stamps another version, or a bundle that reports another version, fails the release.

## `make release VERSION=x.y.z`

The release target prepares a release and stops there. It never pushes anything.

- The version comes from the command line. It never comes from a file in the repository.
- It refuses to run on a dirty working tree.
- It refuses a version whose tag already exists.
- It builds the artifacts.
- It creates an annotated local tag.
- It prints the command that pushes the commit and the tag.

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
| Wallpaper Selector | `WallpaperSelector-<version>.dmg` | `WallpaperSelector-<version>.dmg.sha256` |
| tfm | `tfm-universal-macos.gz` | `tfm-universal-macos.gz.sha256` |

A release that changes the name of an asset needs a change of the pattern in `automation/products.json` first. Otherwise the daily job reports that the release does not hold the file, and it leaves the file of the product in the tap alone.

The checksum file holds one line per asset, in the format of `shasum -a 256`:

```
522894d5b8c0b7bfddc584b7e03a114f9e7bb74876c6c0cb7f4943aa8289f850  Fluor.dmg
```

## The release workflow

The workflow of a product repository runs when the tag is pushed. It does the following.

1. It checks out the repository and resolves the version from the tag.
2. It runs the test suite. A failure stops the release.
3. It builds the artifacts with that version and checks the version of the bundle.
4. It writes the checksum file next to the assets.
5. It publishes the release with the assets, the checksum file and the notes of the CHANGELOG section of that version.

The workflow never writes into the tap and never touches another repository.

## Checking a repository against the contract

- `make help` lists the targets of the repository, and the list holds every target of the table above that the product offers.
- `make test` runs the suite, and it fails when the suite fails.
- `make release-artifacts VERSION=1.2.3` builds the assets, and the produced files carry the names of the table above.
- The names of the produced files and the line of the checksum file are the two things that the tap matches.

The tap checks the same facts from the outside. Its dry run reports the digest of every asset, says whether the checksum file agrees with it and names the products it skipped.

## Deviations

- tfm has no `app` and no `dmg`. It is a command line tool, so it has no application bundle and no disk image. It publishes the universal binary only.
- SketchyBar Studio has no `app-arm` and no `app-intel`, and no `dmg-arm` and no `dmg-intel`. It ships one universal package, so a per-architecture build would produce an artifact that nobody installs.
- SwiftDefaults, Wallpaper Selector and Spaces Renamer have no per-architecture target. They are Apple silicon only, so the plain `app` and `dmg` targets build the only artifact they ship.
