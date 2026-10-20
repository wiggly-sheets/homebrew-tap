# Tap automation

This directory makes the tap the single source of truth for every cask and formula
in it. The files under `Casks/` and the formula at the repository root are
generated output. Nobody edits them by hand: when a product changes, you edit its
template, and the generator writes the new tap file.

There are three moving parts.

`products.json` holds the per-product configuration. For each product it records
the upstream GitHub repository, the release asset that carries the digest, and the
path in the tap where the rendered file goes. It is the only place where the
upstream repositories are named.

`templates/` holds the cask and formula sources, one file per product. The
templates carry everything about a product that a human cares about: the
description, the zap trash list, the macOS dependency, the app bundle name and
the caveats.

`sync-tap.sh` is the generator. It reads the configuration, resolves the latest
release of each upstream repository, renders the templates and writes the result
into the tap.

## The generator contract

`automation/sync-tap.sh --dry-run` resolves every product's latest upstream
release, cross-checks the digest against the published checksum sidecar, renders
the template into a temp copy, lints it, and prints a report. It writes nothing
to the repository. This is the default mode.

`automation/sync-tap.sh --apply` does the same checks, then writes the rendered
files into the repository, commits, and pushes to `main` with a fast-forward
only.

`automation/sync-tap.sh --product <name>` restricts the run to one product, which
is how you test a single product. It combines with either `--dry-run` or
`--apply`.

## What the machine writes

Only two values are ever machine-written: the version and the sha256. All the
product copy stays in the template and is curated by hand. If you want to change
the wording of a cask description, you change the template and the next run
carries that change into the tap.

The generator refuses to write when the release checksum sidecar disagrees with
the digest GitHub reports. Homebrew's own CI does not validate digests, so a
mismatch means the tap would publish a file that nobody can verify, and the run
stops instead of committing it.

## The daily schedule

The daily schedule lives in `.github/workflows/sync-tap.yml`. The workflow runs
once a day at 11:00 UTC. The same job can also be started by hand from the
Actions tab, which is what you do when you want the tap refreshed before the
next scheduled run.
