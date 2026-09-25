# Binary formula. The tarball is the GitHub release asset. The source is not public.
# VERSION and SHA256 must match site/api/_release.ts; site/src/lib/seo/release.test.ts checks it.
class Plottypus < Formula
  desc "Apple Silicon system monitor for the terminal: watts, clocks and temperatures"
  homepage "https://plottypus.com"
  url "https://github.com/CLoaKY233/plottypus/releases/download/v1.1.0/plottypus-v1.1.0-macos-arm64.tar.gz"
  # Brew would scan "64" out of "arm64" in the file name, so the version is explicit.
  version "1.1.0"
  sha256 "4d329aa1d011cb3f7ab099f9d97bc7f758e16b3ef4c12c35b7087b107db33402"
  license :cannot_represent

  livecheck do
    url "https://plottypus.com/api/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    root_url "https://github.com/CLoaKY233/plottypus/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, all: "d8a833ecd30a7c7a8185e259b16abc56e0d7a7de76e6e33a2841185e4fbbde02"
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "plottypus"
    doc.install "README.md", "CHANGELOG.md", "THIRD_PARTY_NOTICES.html"
    prefix.install "LICENSE", "EULA.md"
  end

  def caveats
    <<~EOS
      plottypus reads everything it shows without sudo. Its only network request is an
      optional daily update check, off unless you turn it on during onboarding.
      `plottypus doctor` shows what this Mac exposes; `plottypus --demo` plays a
      canned 60 s session.
    EOS
  end

  test do
    assert_match "plottypus #{version}", shell_output("#{bin}/plottypus --version")
    # Hardware-free: the demo session prints one JSON sample.
    assert_match "\"schema_version\":1", shell_output("#{bin}/plottypus --demo --json --procs 1")
  end
end
