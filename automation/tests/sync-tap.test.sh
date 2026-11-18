#!/usr/bin/env bash
#
# Check the report of the generator on a fixture release. gh, the checksum
# download and the Homebrew style check are replaced by stubs, so the test
# needs no network, no release and no Homebrew. Run it with:
#
#   automation/tests/sync-tap.test.sh
#
# The fixture covers only behaviour that the committed and the working copy of
# the generator share: a missing tap file is created, a checksum disagreement
# is refused, a hand edit is refused, and a matching tap file is left alone.
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
generator="${test_dir}/../sync-tap.sh"
digest="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
mismatch="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdee"
status=0

work_dir="$(mktemp -d)"
trap 'rm -rf "${work_dir}"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

expect_status() {
  local expected="$1"
  if [[ "${status}" -ne "${expected}" ]]
  then
    fail "the generator exited ${status}, expected ${expected}"
  fi
}

expect_line() {
  local text="$1"
  local report="$2"
  if ! grep -qF -- "${text}" "${report}"
  then
    fail "the report does not hold the line '${text}'"
  fi
}

# fixture_repo writes a tap with one product, a template, the release data in
# fixture/ and the stubs in bin/.
fixture_repo() {
  local repo="$1"
  local api_digest="$2"
  local sidecar_digest="$3"

  mkdir -p "${repo}/automation/templates" "${repo}/Casks" "${repo}/bin" "${repo}/fixture"
  git init -q "${repo}"
  cp "${generator}" "${repo}/automation/sync-tap.sh"

  cat >"${repo}/automation/products.json" <<'JSON'
{
  "products": [
    {
      "name": "example",
      "repo": "fixture/example",
      "template": "automation/templates/example.rb",
      "target": "Casks/example.rb",
      "version_placeholder": "VERSION_PLACEHOLDER",
      "assets": [
        {
          "pattern": "Example-{version}.dmg",
          "placeholder": "SHA256_PLACEHOLDER"
        }
      ],
      "sidecar": "checksums.txt"
    }
  ]
}
JSON

  cat >"${repo}/automation/templates/example.rb" <<'RUBY'
# frozen_string_literal: true

# Generated from automation/templates/example.rb. Edit the template, not this file.
cask "example" do
  version "VERSION_PLACEHOLDER"
  sha256 "SHA256_PLACEHOLDER"

  url "https://github.com/fixture/example/releases/download/v#{version}/Example-#{version}.dmg"
  name "Example"
  desc "Example cask for the generator test"
  homepage "https://github.com/fixture/example"

  app "Example.app"
end
RUBY

  printf 'v1.2.3\n' >"${repo}/fixture/tag.txt"
  printf '%s  Example-1.2.3.dmg\n' "${sidecar_digest}" >"${repo}/fixture/checksums.txt"
  printf 'Example-1.2.3.dmg\tsha256:%s\t101\nchecksums.txt\tsha256:%s\t102\n' \
    "${api_digest}" "${api_digest}" >"${repo}/fixture/assets.tsv"

  cat >"${repo}/bin/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

endpoint="$2"
[[ "${endpoint}" == *"/releases/assets/"* ]] && exec cat "${FIXTURE_DIR}/checksums.txt"
[[ "${4:-}" == ".tag_name" ]] && exec cat "${FIXTURE_DIR}/tag.txt"
exec cat "${FIXTURE_DIR}/assets.tsv"
GH

  # The style check is the job of the tap's CI, not of this test.
  printf '#!/usr/bin/env bash\nexit 0\n' >"${repo}/bin/brew"
  chmod +x "${repo}/bin/gh" "${repo}/bin/brew"
}

run_generator() {
  local repo="$1"
  status=0
  (
    cd "${repo}"
    FIXTURE_DIR="${repo}/fixture" PATH="${repo}/bin:${PATH}" automation/sync-tap.sh --dry-run
  ) >"${repo}/report.txt" 2>&1 || status=$?
}

# write_cask writes the tap file that the generator renders, with the given
# description line. A description that differs from the template is a hand edit.
write_cask() {
  local repo="$1"
  local description="$2"

  cat >"${repo}/Casks/example.rb" <<CASKE
# Generated from automation/templates/example.rb. Edit the template, not this file.
cask "example" do
  version "1.2.3"
  sha256 "${digest}"

  url "https://github.com/fixture/example/releases/download/v#{version}/Example-#{version}.dmg"
  name "Example"
  desc "${description}"
  homepage "https://github.com/fixture/example"

  app "Example.app"
end
CASKE
}

# A missing tap file is rendered from the template, counted as changed and not
# written by the dry run.
repo="${work_dir}/create"
fixture_repo "${repo}" "${digest}" "${digest}"
run_generator "${repo}"
expect_status 0
expect_line "Rendered file: new, the tap has no Casks/example.rb yet" "${repo}/report.txt"
expect_line "Rendered files changed: 1" "${repo}/report.txt"
expect_line "Dry run finished. Nothing was written to the tap." "${repo}/report.txt"
if [[ -e "${repo}/Casks/example.rb" ]]
then
  fail "the dry run wrote Casks/example.rb"
fi

# A checksum file that disagrees with the digest of the release skips the
# product and fails the run.
repo="${work_dir}/mismatch"
fixture_repo "${repo}" "${digest}" "${mismatch}"
run_generator "${repo}"
expect_status 1
expect_line "FAILED, the checksum file says" "${repo}/report.txt"
expect_line "Result: FAILED, nothing was written for this product." "${repo}/report.txt"
expect_line "The dry run ends with a failure because a product was skipped." "${repo}/report.txt"

# A tap file that differs from the template in a line the generator does not
# own is left alone, and the run fails.
repo="${work_dir}/hand-edit"
fixture_repo "${repo}" "${digest}" "${digest}"
write_cask "${repo}" "Hand edited description"
run_generator "${repo}"
expect_status 1
expect_line "differs from the tap in more than the marker" "${repo}/report.txt"
if ! grep -qF 'desc "Hand edited description"' "${repo}/Casks/example.rb"
then
  fail "the hand edit did not survive the run"
fi

# A tap file that already holds the rendered text is reported as unchanged.
repo="${work_dir}/current"
fixture_repo "${repo}" "${digest}" "${digest}"
write_cask "${repo}" "Example cask for the generator test"
run_generator "${repo}"
expect_status 0
expect_line "Rendered file: identical to the tap file" "${repo}/report.txt"
expect_line "No changes: every rendered file is already in the tap." "${repo}/report.txt"

printf 'ok: the generator report matches the fixture expectations\n'
