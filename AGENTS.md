# AGENTS.md

## What this repository is

This repository is the one Homebrew tap for every wiggly-sheets product. It is the tap `wiggly-sheets/homebrew-tap`, and it holds six casks under `Casks/` and one formula, `tfm.rb`, at the root of the repository.

Every cask and every formula in the tap is generated output. The source of truth is the template of the product, `automation/templates/<product>.rb`, together with the entry of the product in `automation/products.json`. The generator that turns the two into a tap file is `automation/sync-tap.sh`.

Never hand edit a file under `Casks/` and never hand edit the formula at the root. Edit the template and let the generator write the tap file. A hand edit does not survive a run of the generator: the generator compares the body of the tap file with the body of the template, and when the two differ it stops and writes nothing. The run fails on purpose, so that a hand edit is never overwritten silently.

This guide explains the rules and the steps. `automation/README.md` explains the mechanics of the tool.

## What the machine writes and what a human writes

Only two values in a tap file are machine written: the version and the sha256 digest. Everything else about the product is curated by hand in the template. That is the description, the zap trash list, the macOS dependency, the app bundle name and the caveats. Change the template when you want to change any of them, and the next run of the generator carries the change into the tap.

## A new release of an existing product

Nothing has to be done by hand. The daily job in `.github/workflows/sync-tap.yml` runs at 11:00 UTC. It reads the latest stable release of each upstream repository, checks the digest that GitHub reports against the checksum file that the release publishes, renders the template, lints the result and pushes the new tap file to `main`.

For the job to publish a release, that release must hold two things.

1. An asset whose name matches the pattern of the product in `automation/products.json`. A pattern may hold `{version}`, which the generator replaces with the release tag without its leading `v`. A product with two assets has one pattern per asset.
2. A checksum file, named as the `sidecar` of the product in `automation/products.json`. The name of that file may hold `{version}` as well. One of its lines holds the digest and the name of the asset, separated by spaces:

   ```
   522894d5b8c0b7bfddc584b7e03a114f9e7bb74876c6c0cb7f4943aa8289f850  Fluor.dmg
   ```

A prerelease is ignored, because the job reads the latest release that GitHub reports as the latest one. If the digest that GitHub reports and the checksum file disagree, the run fails and writes nothing. If a release changes the name of its asset, change the pattern in `automation/products.json` first, or the job reports that the release does not hold the file.

To start the job by hand, open the Actions tab of the repository, choose the workflow "sync tap with upstream releases" and use the "Run workflow" button.

## A completely new product

1. Publish the first release of the product upstream. It needs the asset and the checksum file, in the shape described above.
2. Write the template in `automation/templates/<product>.rb`. Follow the shape of an existing template: the frozen string literal comment, an empty line, the marker line that names the template, and the placeholders that the generator replaces.
3. Add the entry of the product in `automation/products.json`. The entry names the upstream repository, the template, the path that the rendered file takes in the tap, the version placeholder, one pattern and one placeholder per asset, and the checksum file.
4. Run the generator in dry run mode and read the report: `automation/sync-tap.sh --dry-run --product <product>`. The report says whether the release resolved, whether the digests agreed and whether the rendered file passes the lint. It writes nothing to the repository.
5. Commit the template and the configuration. Do not commit a rendered cask, because the generator writes that file.
6. Let the next run of the job write the cask. Start the job by hand from the Actions tab when you do not want to wait for the schedule.

Keep to these rules in the template of a new product.

- Give a cask for a macOS only application a `depends_on macos: :<release>`. Homebrew reports a cask that has an `app` stanza and no macOS dependency.
- Keep the platform out of the description. "macOS", "Mac OS" and "OS X" in the description of a cask are reported by the style check of Homebrew.
- Write the zap trash list in alphabetical order.
- Put a formula in the root of the repository, because this tap has no `Formula` directory. Put the casks in the directory named `Casks`.

## The Homebrew rules that bite

- The casks go into the directory named `Casks` and the formula lives in the root of the repository. `Formulae` is not recognised at all.
- The files of the tap carry no Sorbet sigil and no frozen string literal comment. The style check of Homebrew exempts a tap from the sigil rules, and it accepts a missing frozen string literal comment only in the files that sit in a cask or a formula directory. A template needs the comment, because it sits in neither, and the generator strips the comment before it writes the tap file.
- The audit of Homebrew only checks the format of a digest. It never checks that the digest is the digest of the file that the URL points to. That is why the generator compares the digest with the checksum file that the release publishes.

## Check your work before you commit

Run the generator in dry run mode. `automation/sync-tap.sh --dry-run` resolves every product, cross-checks the digests, renders the templates and lints the result in a temporary copy of the tap, and it writes nothing. Add `--product <product>` to look at a single product. Do not run `--apply` by hand: that mode writes the files, commits them and pushes to `main`, and the daily job owns that.

Run the lint the way the CI runs it. A lint outside the Library directory of Homebrew reports findings that the CI does not report, so put the committed files into a scratch tap first:

```
mkdir -p /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
git archive HEAD | tar -x -C /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
cd /opt/homebrew/Library/Taps/zzscratch/homebrew-tap
git init
brew style zzscratch/tap
```

The scratch tap must hold the committed files, because the CI checks out the commit, and a file that is not committed is not linted by the CI.

Remove the scratch directory when you are done with it.

The CI of the tap lints the whole repository, so a new shell script and a new template have to satisfy the style rules of Homebrew as well. `brew test-bot --only-tap-syntax` runs `brew style` over the tap, and that covers RuboCop for the Ruby files, ShellCheck and shfmt for the shell script, and actionlint for the workflow files.

## The paths that matter

- `Casks/` holds the generated cask files. Never edit them.
- `tfm.rb` is the generated formula at the root of the repository. Never edit it.
- `automation/templates/` holds the templates, one per product. Edit these.
- `automation/products.json` holds the configuration: the upstream repository, the release assets, the checksum file and the target path of every product.
- `automation/sync-tap.sh` is the generator.
- `automation/README.md` explains the mechanics of the generator and of the lint.
- `.github/workflows/sync-tap.yml` is the daily job.
- `.github/workflows/tests.yml` holds the checks of the tap.
- `README.md` holds the table of the products.
