# cloaky233/tap

```sh
brew install cloaky233/tap/plottypus
```

plottypus is installed from the release tarball. The Rust source is not in this tap.

## Releasing

After the formula has the new `url`, `version` and `sha256`, run `scripts/bottle.sh vX.Y.Z` on an
Apple Silicon Mac and commit the formula. The bottle lets Homebrew pour the prebuilt binary
instead of treating the formula as a source build, which would ask for current Command Line Tools.
