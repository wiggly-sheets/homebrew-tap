#!/usr/bin/env bash
#
# Regenerate the casks and the formula of this tap from the upstream releases.
#
# The files in this tap are output. They are never edited by hand. This script
# reads the latest release of every upstream repository, renders the matching
# template from automation/templates and writes the result into the tap. The
# upstream repositories are never written to.
#
# Usage:
#   automation/sync-tap.sh --dry-run                  Resolve, cross-check and lint. Writes nothing.
#   automation/sync-tap.sh --dry-run --product fluor  Do the same for one product only.
#   automation/sync-tap.sh --apply                    Do the same, then write, commit and push to main.
#
# It needs gh (authenticated), python3, awk, sed, grep, git and brew.

set -euo pipefail

program_name="${0##*/}"
mode="dry-run"
product_filter=""

usage() {
	cat <<EOF
Usage: $program_name [--dry-run | --apply] [--product <name>]

  --dry-run  Resolve every product, cross-check the digests against the
             upstream checksum files and lint the rendered files. Nothing is
             written to the tap. This is the default.
  --apply    Do the same, then write the rendered files into the tap, commit
             them and push the commit to the main branch of origin.
  --product  Restrict the run to one product from the configuration. It works
             with either mode.
EOF
}

while [ "$#" -gt 0 ]; do
	case "$1" in
	--dry-run)
		mode="dry-run"
		;;
	--apply)
		mode="apply"
		;;
	--product)
		if [ "$#" -lt 2 ]; then
			printf 'The --product option needs the name of a product.\n\n' >&2
			usage >&2
			exit 2
		fi
		product_filter="$2"
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		printf 'Unknown option: %s\n\n' "$1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

products_file="automation/products.json"
if [ ! -f "$products_file" ]; then
	printf 'ERROR: %s does not exist.\n' "$products_file" >&2
	exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
	printf 'ERROR: python3 is required to read %s.\n' "$products_file" >&2
	exit 1
fi

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

# The lint has to run on each file at the path it will have inside the tap, so
# that the Homebrew cops see a real tap layout. The repository itself is never
# written to during a dry run, so the tap is copied into a temporary directory
# and the rendered files are placed there at their final path.
mirror="$work_dir/tap"
mkdir -p "$mirror"
for entry in "$repo_root"/* "$repo_root"/.[!.]*; do
	if [ ! -e "$entry" ]; then
		continue
	fi
	if [ "${entry##*/}" = ".git" ]; then
		continue
	fi
	cp -R "$entry" "$mirror/"
done

# The product list is read with python3, which turns the JSON configuration into
# the records the shell reads. The records are one per line and the fields are
# separated by a pipe. A product is six records, one per field, followed by one
# record per asset and an empty line that ends the product.
parse_products() {
	python3 - "$1" <<'PYTHON'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    config = json.load(handle)

for product in config["products"]:
    print("name|{}".format(product["name"]))
    print("repo|{}".format(product["repo"]))
    print("template|{}".format(product["template"]))
    print("target|{}".format(product["target"]))
    print("sidecar|{}".format(product["sidecar"]))
    print("version_placeholder|{}".format(product["version_placeholder"]))
    for asset in product["assets"]:
        print("asset|{}|{}".format(asset["pattern"], asset["placeholder"]))
    print()
PYTHON
}

# The configuration is read once and the records are kept in a file, so that the
# report and the apply step read exactly the same products.
products_records="$work_dir/products.tsv"
parse_products "$products_file" >"$products_records"

# The optional --product option picks a single product out of the configuration.
products_input="$products_records"
if [ -n "$product_filter" ]; then
	known_products="$(awk -F'|' '$1 == "name" { print $2 }' "$products_records")"
	if ! printf '%s\n' "$known_products" | grep -Fxq "$product_filter"; then
		printf 'ERROR: %s is not a product in %s.\n' "$product_filter" "$products_file" >&2
		printf 'Known products:\n' >&2
		printf '%s\n' "$known_products" | sed 's/^/  /' >&2
		exit 2
	fi
	products_input="$work_dir/products-selected.tsv"
	awk -F'|' -v wanted="$product_filter" '
		$1 == "name" { keep = ($2 == wanted) }
		keep { print }
	' "$products_records" >"$products_input"
fi

# gh_api calls the GitHub API and prints the result of a jq filter. The call is
# retried a few times because the network is not always reliable.
gh_api() {
	local endpoint="$1"
	local filter="$2"
	local attempt
	for attempt in 1 2 3 4; do
		if gh api "$endpoint" --jq "$filter" 2>"$work_dir/gh-error.txt"; then
			return 0
		fi
		if [ "$attempt" -lt 4 ]; then
			printf '  The request to %s failed, retrying (%s of 4).\n' "$endpoint" "$attempt" >&2
			sleep $((attempt * 2))
		fi
	done
	printf '  The request to %s failed.\n' "$endpoint" >&2
	sed 's/^/    /' "$work_dir/gh-error.txt" >&2
	return 1
}

# gh_download saves a release asset in a local file.
gh_download() {
	local endpoint="$1"
	local destination="$2"
	local attempt
	for attempt in 1 2 3 4; do
		if gh api "$endpoint" -H 'Accept: application/octet-stream' >"$destination" 2>"$work_dir/gh-error.txt"; then
			return 0
		fi
		if [ "$attempt" -lt 4 ]; then
			printf '  The download of %s failed, retrying (%s of 4).\n' "$endpoint" "$attempt" >&2
			sleep $((attempt * 2))
		fi
	done
	printf '  The download of %s failed.\n' "$endpoint" >&2
	sed 's/^/    /' "$work_dir/gh-error.txt" >&2
	return 1
}

# find_asset prints the digest and the id of the release asset with the given
# name. The assets file holds one tab separated line per asset.
find_asset() {
	awk -F '\t' -v wanted="$2" '$1 == wanted { print $2 "\t" $3; exit }' "$1"
}

# sidecar_digest_for prints the checksum that the sidecar file records for the
# given file name. The sidecar may name the file with a path, so only the last
# part of the name is compared.
sidecar_digest_for() {
	awk -v wanted="$2" '
    {
      count = NF
      if (count == 0) {
        next
      }
      filename = $count
      sub(/^\*/, "", filename)
      parts = split(filename, segments, "/")
      if (segments[parts] != wanted) {
        next
      }
      print $1
      exit
    }
  ' "$1"
}

# escape_replacement makes a value safe to use as the replacement of a sed
# expression.
escape_replacement() {
	printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g'
}

# render_template writes the template to the output file, replacing every
# placeholder with its value. The arguments are placeholder and value pairs.
render_template() {
	local template="$1"
	local output="$2"
	shift 2
	local -a expressions=()
	while [ "$#" -gt 0 ]; do
		local placeholder="$1"
		local value="$2"
		shift 2
		expressions+=(-e "s|${placeholder}|$(escape_replacement "$value")|g")
	done
	sed "${expressions[@]}" "$template" >"$output"
}

# lint_rendered checks the rendered file. The Ruby syntax check comes first and
# the Homebrew style check runs on the file at its final path inside the copy
# of the tap, so that the cops see the same layout they would see in the tap.
lint_rendered() {
	local relative_path="$1"
	local cops="$2"
	local staged="$mirror/$relative_path"

	if ! ruby -c "$staged" >"$work_dir/ruby.txt" 2>&1; then
		printf '  Ruby syntax: FAILED\n'
		sed 's/^/    /' "$work_dir/ruby.txt"
		return 1
	fi
	printf '  Ruby syntax: ok\n'

	if ! (cd "$mirror" && HOMEBREW_NO_AUTO_UPDATE=1 brew style --only-cops "$cops" "$relative_path") \
		>"$work_dir/style.txt" 2>&1; then
		printf '  brew style (%s): FAILED\n' "$cops"
		sed 's/^/    /' "$work_dir/style.txt"
		return 1
	fi
	printf '  brew style (%s): no offenses\n' "$cops"
}

product_name=""
product_repo=""
product_template=""
product_target=""
product_sidecar=""
product_version_placeholder=""
asset_patterns=()
asset_placeholders=()

products_total=0
products_failed=0
products_changed=0
cross_checks_matched=0
changed_products=()
apply_targets=()

reset_product() {
	product_name=""
	product_repo=""
	product_template=""
	product_target=""
	product_sidecar=""
	product_version_placeholder=""
	asset_patterns=()
	asset_placeholders=()
}

# sync_product resolves one product, checks the digests, renders the template
# and lints the result. It returns non zero when the product fails.
sync_product() {
	local tag version pattern filename entry digest sidecar_filename sidecar_entry
	local sidecar_path sidecar_digest rendered relative_path status index lint_cops
	local -a digests=()
	local -a substitutions=()

	printf '\nProduct: %s\n' "$product_name"
	printf '  Upstream repository: %s\n' "$product_repo"
	printf '  Template:            %s\n' "$product_template"
	printf '  Target:              %s\n' "$product_target"

	if [ -z "$product_repo" ] || [ -z "$product_template" ] || [ -z "$product_target" ] ||
		[ -z "$product_sidecar" ] || [ -z "$product_version_placeholder" ] ||
		[ "${#asset_patterns[@]}" -eq 0 ]; then
		printf '  Result: FAILED, the entry in %s is incomplete.\n' "$products_file"
		return 1
	fi

	if [ ! -f "$product_template" ]; then
		printf '  Result: FAILED, the template %s does not exist.\n' "$product_template"
		return 1
	fi

	if ! printf '%s' "$product_version_placeholder" | grep -Eq '^[A-Za-z0-9_]+$'; then
		printf '  Result: FAILED, the version placeholder must be a plain token.\n'
		return 1
	fi

	if ! tag="$(gh_api "repos/$product_repo/releases/latest" '.tag_name')"; then
		printf '  Result: FAILED, the latest release could not be read.\n'
		return 1
	fi
	version="${tag#v}"
	printf '  Latest release tag:  %s\n' "$tag"
	printf '  Version:             %s\n' "$version"

	local assets_file="$work_dir/assets-$product_name.tsv"
	if ! gh_api "repos/$product_repo/releases/latest" \
		'.assets[] | [.name, .digest, (.id | tostring)] | @tsv' >"$assets_file"; then
		printf '  Result: FAILED, the release assets could not be read.\n'
		return 1
	fi

	status="ok"
	for index in "${!asset_patterns[@]}"; do
		pattern="${asset_patterns[$index]}"
		filename="${pattern//\{version\}/$version}"
		entry="$(find_asset "$assets_file" "$filename")"
		if [ -z "$entry" ]; then
			printf '  Asset %s: FAILED, the release does not contain this file.\n' "$filename"
			digests+=("")
			status="failed"
			continue
		fi
		digest="${entry%%$'\t'*}"
		digest="${digest#sha256:}"
		if ! printf '%s' "$digest" | grep -Eq '^[0-9a-f]{64}$'; then
			printf '  Asset %s: FAILED, GitHub reports no sha256 digest for it.\n' "$filename"
			digests+=("")
			status="failed"
			continue
		fi
		digests+=("$digest")
		printf '  Asset %s\n' "$filename"
		printf '    Digest from the GitHub API: %s\n' "$digest"
	done

	sidecar_filename="${product_sidecar//\{version\}/$version}"
	sidecar_entry="$(find_asset "$assets_file" "$sidecar_filename")"
	if [ -z "$sidecar_entry" ]; then
		printf '  Sidecar %s: FAILED, the release does not contain this checksum file.\n' "$sidecar_filename"
		status="failed"
	else
		sidecar_path="$work_dir/sidecar-$product_name"
		if ! gh_download "repos/$product_repo/releases/assets/${sidecar_entry#*$'\t'}" "$sidecar_path"; then
			printf '  Sidecar %s: FAILED, the checksum file could not be downloaded.\n' "$sidecar_filename"
			status="failed"
		else
			printf '  Sidecar %s\n' "$sidecar_filename"
			for index in "${!asset_patterns[@]}"; do
				digest="${digests[$index]}"
				if [ -z "$digest" ]; then
					continue
				fi
				filename="${asset_patterns[$index]//\{version\}/$version}"
				sidecar_digest="$(sidecar_digest_for "$sidecar_path" "$filename")"
				if [ -z "$sidecar_digest" ]; then
					printf '    %s: FAILED, the checksum file has no line for this file.\n' "$filename"
					status="failed"
				elif [ "$sidecar_digest" != "$digest" ]; then
					printf '    %s: FAILED, the checksum file says %s and the GitHub API says %s.\n' \
						"$filename" "$sidecar_digest" "$digest"
					status="failed"
				else
					printf '    %s: the checksum file agrees (%s)\n' "$filename" "$sidecar_digest"
					cross_checks_matched=$((cross_checks_matched + 1))
				fi
			done
		fi
	fi

	if [ "$status" != "ok" ]; then
		printf '  Result: FAILED, nothing was written for this product.\n'
		return 1
	fi

	if ! grep -qF "$product_version_placeholder" "$product_template"; then
		printf '  Result: FAILED, the template %s does not contain the placeholder %s.\n' \
			"$product_template" "$product_version_placeholder"
		return 1
	fi
	for index in "${!asset_placeholders[@]}"; do
		if ! printf '%s' "${asset_placeholders[$index]}" | grep -Eq '^[A-Za-z0-9_]+$'; then
			printf '  Result: FAILED, a placeholder must be a plain token.\n'
			return 1
		fi
		if ! grep -qF "${asset_placeholders[$index]}" "$product_template"; then
			printf '  Result: FAILED, the template %s does not contain the placeholder %s.\n' \
				"$product_template" "${asset_placeholders[$index]}"
			return 1
		fi
	done

	rendered="$mirror/$product_target"
	mkdir -p "${rendered%/*}"
	substitutions=("$product_version_placeholder" "$version")
	for index in "${!asset_placeholders[@]}"; do
		substitutions+=("${asset_placeholders[$index]}" "${digests[$index]}")
	done
	render_template "$product_template" "$rendered" "${substitutions[@]}"

	if grep -q 'PLACEHOLDER' "$rendered"; then
		printf '  Result: FAILED, the rendered file still contains a placeholder.\n'
		return 1
	fi

	# Every checksum in the rendered file must be one of the digests that the
	# release reports. A placeholder that does not match the template would
	# leave a stray character next to the checksum.
	while IFS= read -r run; do
		known=0
		for index in "${!digests[@]}"; do
			if [ "${digests[$index]}" = "$run" ]; then
				known=1
				break
			fi
		done
		if [ "$known" -ne 1 ]; then
			printf '  Result: FAILED, the rendered file holds the checksum %s, which the release does not report.\n' "$run"
			return 1
		fi
	done < <(grep -Eo '[0-9a-fA-F]{32,}' "$rendered" || true)

	for index in "${!digests[@]}"; do
		if [ -n "${digests[$index]}" ] && ! grep -qF "\"${digests[$index]}\"" "$rendered"; then
			printf '  Result: FAILED, the checksum %s did not reach the rendered file.\n' "${digests[$index]}"
			return 1
		fi
	done

	# The version has to reach the rendered file as often as the template
	# mentions the placeholder, and it must not run into another character.
	version_wanted=$(grep -oF "$product_version_placeholder" "$product_template" | wc -l)
	version_found=$(grep -oF "$version" "$rendered" | wc -l)
	if [ "$version_found" -lt "$version_wanted" ]; then
		printf '  Result: FAILED, the version %s did not reach the rendered file.\n' "$version"
		return 1
	fi
	version_pattern=$(printf '%s' "$version" | sed -e 's/[^A-Za-z0-9]/\\&/g')
	if grep -qE "${version_pattern}[A-Za-z0-9_]" "$rendered"; then
		printf '  Result: FAILED, the version %s runs into another character in the rendered file.\n' "$version"
		return 1
	fi

	relative_path="$product_target"
	if [ -f "$repo_root/$product_target" ]; then
		if diff -u --label "$product_target (current tap file)" --label "$product_target (rendered)" \
			"$repo_root/$product_target" "$rendered" >"$work_dir/diff.txt" 2>&1; then
			printf '  Rendered file: unchanged\n'
		else
			if diff -u <(tail -n +2 "$rendered") "$repo_root/$product_target" >"$work_dir/diff-header.txt" 2>&1; then
				printf '  Rendered file: differs from the tap only by the template header comment\n'
			else
				printf '  Rendered file: differs from the tap in more than the template header comment\n'
			fi
			printf '  Diff against the current tap file:\n'
			sed 's/^/    /' "$work_dir/diff.txt"
			products_changed=$((products_changed + 1))
			changed_products+=("$product_name $version")
		fi
	else
		diff -u --label "$product_target (current tap file)" --label "$product_target (rendered)" \
			/dev/null "$rendered" >"$work_dir/diff.txt" 2>&1 || true
		printf '  Rendered file: new, the tap has no %s yet\n' "$product_target"
		printf '  Diff against the current tap file:\n'
		sed 's/^/    /' "$work_dir/diff.txt"
		products_changed=$((products_changed + 1))
		changed_products+=("$product_name $version")
	fi

	if [ "${product_target#Casks/}" = "$product_target" ]; then
		lint_cops="Cask,Homebrew,FormulaAudit"
	else
		lint_cops="Cask,Homebrew"
	fi
	if ! lint_rendered "$relative_path" "$lint_cops"; then
		printf '  Result: FAILED, the lint reported offenses.\n'
		return 1
	fi

	printf '  Result: ok\n'
	return 0
}

printf 'Tap sync report\n'
printf '===============\n\n'
printf 'Repository: %s\n' "$repo_root"
printf 'Mode:       %s\n' "$mode"
printf 'Products:   %s\n\n' "$products_file"
if [ -n "$product_filter" ]; then
	printf 'Product:    %s\n\n' "$product_filter"
fi

while IFS='|' read -r field first second; do
	case "$field" in
	name)
		product_name="$first"
		;;
	repo)
		product_repo="$first"
		;;
	template)
		product_template="$first"
		;;
	target)
		product_target="$first"
		;;
	sidecar)
		product_sidecar="$first"
		;;
	version_placeholder)
		product_version_placeholder="$first"
		;;
	asset)
		asset_patterns+=("$first")
		asset_placeholders+=("$second")
		;;
	"")
		if [ -n "$product_name" ]; then
			products_total=$((products_total + 1))
			if ! sync_product; then
				products_failed=$((products_failed + 1))
			fi
		fi
		reset_product
		;;
	esac
done <"$products_input"

printf '\nSummary\n'
printf '%s\n' '-------'
printf '  Products processed:     %s\n' "$products_total"
printf '  Products failed:        %s\n' "$products_failed"
printf '  Digest cross-checks:    %s matched\n' "$cross_checks_matched"
printf '  Rendered files changed: %s\n' "$products_changed"

if [ "$products_failed" -ne 0 ]; then
	printf '\nAt least one product failed, so nothing was written.\n'
	exit 1
fi

if [ "$products_changed" -eq 0 ]; then
	printf '\nNo changes: every rendered file is already in the tap.\n'
	exit 0
fi

if [ "$mode" = "dry-run" ]; then
	printf '\nDry run finished. Nothing was written to the tap.\n'
	exit 0
fi

# From here on the script writes to the tap.
git -C "$repo_root" ls-files --others --exclude-standard >"$work_dir/untracked-before.txt"

while IFS='|' read -r field first second; do
	if [ "$field" = "target" ]; then
		apply_targets+=("$first")
	fi
done <"$products_input"

for target in "${apply_targets[@]}"; do
	cp "$mirror/$target" "$repo_root/$target"
done

# The script may only write the configured targets. Anything else that changed
# in the working tree aborts the run.
is_allowed_target() {
	local candidate="$1"
	local allowed
	for allowed in "${apply_targets[@]}"; do
		if [ "$candidate" = "$allowed" ]; then
			return 0
		fi
	done
	return 1
}

ownership_ok=1
while IFS= read -r path; do
	if [ -z "$path" ]; then
		continue
	fi
	if ! is_allowed_target "$path"; then
		printf 'ERROR: %s changed but it is not a configured target.\n' "$path" >&2
		ownership_ok=0
	fi
done < <(git -C "$repo_root" diff --name-only)
while IFS= read -r path; do
	if [ -z "$path" ]; then
		continue
	fi
	if ! is_allowed_target "$path"; then
		printf 'ERROR: %s is staged but it is not a configured target.\n' "$path" >&2
		ownership_ok=0
	fi
done < <(git -C "$repo_root" diff --cached --name-only)
while IFS= read -r path; do
	if [ -z "$path" ]; then
		continue
	fi
	if ! is_allowed_target "$path"; then
		if ! grep -Fxq "$path" "$work_dir/untracked-before.txt"; then
			printf 'ERROR: %s is a new untracked file and it is not a configured target.\n' "$path" >&2
			ownership_ok=0
		fi
	fi
done < <(git -C "$repo_root" ls-files --others --exclude-standard)

if [ "$ownership_ok" -ne 1 ]; then
	printf 'ERROR: the working tree holds changes that this script did not make.\n' >&2
	exit 1
fi

git -C "$repo_root" add -- "${apply_targets[@]}"

{
	printf 'chore(tap): sync casks to the latest upstream releases\n'
	printf '\n'
	for product in "${changed_products[@]}"; do
		printf '%s: updated to %s\n' "${product%% *}" "${product##* }"
	done
} >"$work_dir/commit-message.txt"

git -C "$repo_root" commit --file="$work_dir/commit-message.txt"

git -C "$repo_root" fetch origin main
if ! git -C "$repo_root" merge-base --is-ancestor origin/main HEAD; then
	printf 'ERROR: the push to main would not be a fast forward.\n' >&2
	exit 1
fi
git -C "$repo_root" push origin HEAD:main

printf '\nThe tap is up to date and the commit was pushed to origin main.\n'
