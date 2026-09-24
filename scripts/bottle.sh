#!/usr/bin/env bash
# Build the plottypus bottle for a release, upload it, and point the formula at it.
#
#   scripts/bottle.sh v1.0.1
#
# Run on an Apple Silicon Mac after Formula/plottypus.rb has the new url, version
# and sha256. A bottle lets `brew install` pour the prebuilt binary instead of
# treating the formula as a source build, which would demand current Command
# Line Tools. One `all` bottle serves every macOS: the binary's minimum is 11.0.
set -euo pipefail
tag=${1:?usage: scripts/bottle.sh vX.Y.Z}
version=${tag#v}
repo=CLoaKY233/plottypus
tap_dir=$(cd "$(dirname "$0")/.." && pwd)
formula="${tap_dir}/Formula/plottypus.rb"
root_url="https://github.com/${repo}/releases/download/${tag}"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1

grep -q "version \"${version}\"" "$formula" || { echo "formula is not at ${version}" >&2; exit 1; }
# Homebrew only builds formulae that live in a tap, so build this checkout's formula,
# minus its bottle block (that names the old release), from the installed tap copy.
brew tap cloaky233/tap >/dev/null
installed="$(brew --repository cloaky233/tap)/Formula/plottypus.rb"
cp "$installed" "${work}/installed.rb"
trap 'cp "${work}/installed.rb" "$installed"; rm -rf "$work"' EXIT
sed '/^  bottle do$/,/^  end$/d' "$formula" > "$installed"
brew uninstall -q --formula plottypus 2>/dev/null || true
brew install --build-bottle cloaky233/tap/plottypus
(cd "$work" && brew bottle --no-rebuild --root-url="$root_url" cloaky233/tap/plottypus)
bottle="${work}/plottypus-${version}.all.bottle.tar.gz"
mv "${work}"/plottypus--"${version}".*.bottle.tar.gz "$bottle"
sha=$(shasum -a 256 "$bottle" | cut -d ' ' -f 1)
gh release upload "$tag" "$bottle" --repo "$repo" --clobber

python3 - "$formula" "$root_url" "$sha" <<'PY'
import re, sys
path, root_url, sha = sys.argv[1:]
src = open(path).read()
block = (f'  bottle do\n    root_url "{root_url}"\n'
         f'    sha256 cellar: :any_skip_relocation, all: "{sha}"\n  end\n\n')
src = re.sub(r'  bottle do\n.*?\n  end\n\n', '', src, flags=re.S)
src = src.replace('  depends_on arch: :arm64', block + '  depends_on arch: :arm64', 1)
open(path, 'w').write(src)
PY
ruby -c "$formula" >/dev/null
brew uninstall -q --formula plottypus
echo "bottle ${sha}. Commit Formula/plottypus.rb, push, then: brew update && brew install cloaky233/tap/plottypus"
