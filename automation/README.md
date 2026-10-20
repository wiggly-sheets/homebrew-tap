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

A product that fails is skipped. The file of a skipped product is never written
into the tap, and the other products sync as usual. The report names the
skipped products, the commit that the apply step makes names them too, and the
run ends with a non-zero exit code, so that the daily job turns red. A skipped
product keeps the version it has in the tap until someone fixes it.

`automation/sync-tap.sh --product <name>` restricts the run to one product, which
is how you test a single product. It combines with either `--dry-run` or
`--apply`.

## What the machine writes

Only two values are ever machine-written: the version and the sha256. All the
product copy stays in the template and is curated by hand. If you want to change
the wording of a cask description, you change the template and the next run
carries that change into the tap.

The generator refuses to write a product when the release checksum sidecar
disagrees with the digest GitHub reports. Homebrew's own CI does not validate
digests, so a mismatch means the tap would publish a file that nobody can
verify. The product is skipped, the other products still sync, and the run ends
with a non-zero exit code.

Every generated tap file starts with a marker line that names the template it
comes from. The marker tells a reader that the file is generated output and
points them at the template, which is the file to edit. For the cask of fluor
the marker reads:

    # The tap's fluor cask comes from automation/templates/fluor.rb. Edit the template to change it.

To change a cask or a formula, edit its template and run the generator again.
The next write puts the new text into the tap.

The generator compares the body of the tap file with the body of the template,
after it removes the marker line from both sides. When the bodies are equal and
the tap file has no marker line yet, the next write adds the marker line to the
tap file. When the bodies differ, the product is skipped and its file is left
alone, so a hand edited tap file or a stale template is never overwritten
silently. The other products still sync and the run ends with a non-zero exit
code.

## The templates and the lint

The tap's own CI runs `brew style` on the whole tap, so the templates are
linted as well. Homebrew's RuboCop configuration only allows the frozen string
literal comment to be missing from files that live under a `Casks` or a
`Formula` directory, and the templates live in `automation/templates`. Every
template therefore starts with the frozen string literal comment and an empty
line:

    # frozen_string_literal: true

The empty line is required as well: Homebrew's RuboCop configuration wants an
empty line after the magic comment.

The rendered tap file must carry neither the comment nor the empty line.
Homebrew's own cask files do not freeze their strings, and a frozen string in a
cask can break the cask DSL at runtime. The generator removes the comment and
the empty line from the template before it renders it, so the file in the tap
starts with the marker line and holds no frozen string literal comment.

A template also holds the RuboCop directives that the template itself needs.
The formula of tfm carries this directive:

    # rubocop:disable FormulaAudit/Checksum, FormulaAudit/ChecksumCase, Lint/DuplicateMethods

The digest of a template is a placeholder and not a real sha256, so the
`FormulaAudit` cops would report it. The formula of the template and the
formula in the tap hold the same method, so the `Lint/DuplicateMethods` cop
would report the method of the template as a duplicate. The directive turns
both reports off for the template. The generator removes the directives before
it renders a template, so they never reach the tap.

## The shell script and the lint

The tap's CI runs ShellCheck and shfmt on `automation/sync-tap.sh`. The script
is formatted the way Homebrew formats its own shell scripts: two spaces of
indentation and `then` and `do` on a line of their own. The file
`.shellcheckrc` in the root of the tap turns off the same three ShellCheck
checks that Homebrew turns off for its own scripts. The generator calls its own
functions in conditions on purpose, and ShellCheck reports that as a problem.
The file makes a local ShellCheck run report the same findings as the run of
the tap's CI.

## Reproducing the lint locally

`brew style <tap-name>` lints the tap clone that Homebrew keeps under its
Library/Taps directory, and Homebrew's RuboCop configuration excludes the
Sorbet sigil cops for everything in that tap. Running `brew style .` in a
working copy outside that directory reports Sorbet sigil complaints for the
templates that the tap's CI does not report, so the two runs do not agree.

Use a scratch tap under the Homebrew Library/Taps directory when the exact CI
verdict matters:

    mkdir -p /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
    cp -R . /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
    cd /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
    git init
    brew style zzscratch/tap

Remove the scratch directory when you are done with it.

## The daily schedule

The daily schedule lives in `.github/workflows/sync-tap.yml`. The workflow runs
once a day at 11:00 UTC. The same job can also be started by hand from the
Actions tab, which is what you do when you want the tap refreshed before the
next scheduled run.
