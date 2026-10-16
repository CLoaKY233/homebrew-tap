# Generated for siltop v1.2.0 by release.yml; edits here are overwritten.
class Siltop < Formula
  desc "Apple Silicon system monitor for the terminal: watts, clocks and temperatures"
  homepage "https://github.com/CLoaKY233/siltop"
  url "https://github.com/CLoaKY233/siltop/releases/download/v1.2.0/siltop-v1.2.0-macos-arm64.tar.gz"
  # Brew would scan "64" out of "arm64" in the file name, so the version is explicit.
  version "1.2.0"
  sha256 "08cf6d42b9abcb4ace7d760cdb5ebd574e6ebd2400f8cf62b9dc6a50fdf70df8"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/CLoaKY233/siltop/releases/download/v1.2.0"
    sha256 cellar: :any_skip_relocation, all: "019c2467bcf04be7146d14239025f4433fb7e2aa190b6a2e804a2b927e046f65"
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "siltop"
    doc.install "README.md", "CHANGELOG.md", "THIRD_PARTY_NOTICES.html"
    prefix.install "LICENSE-MIT", "LICENSE-APACHE"
  end

  def caveats
    <<~EOS
      siltop reads everything it shows without sudo. Its only network request is an
      optional daily update check, off unless you turn it on during onboarding.
      `siltop doctor` shows what this Mac exposes; `siltop --demo` plays a canned
      60 s session.
    EOS
  end

  test do
    assert_match "siltop #{version}", shell_output("#{bin}/siltop --version")
    # Hardware-free: the demo session prints one JSON sample.
    assert_match "\"schema_version\":1", shell_output("#{bin}/siltop --demo --json --procs 1")
  end
end
