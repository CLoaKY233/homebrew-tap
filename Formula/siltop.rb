# Generated for siltop v1.2.1 by release.yml; edits here are overwritten.
class Siltop < Formula
  desc "Apple Silicon system monitor for the terminal: watts, clocks and temperatures"
  homepage "https://github.com/CLoaKY233/siltop"
  url "https://github.com/CLoaKY233/siltop/releases/download/v1.2.1/siltop-v1.2.1-macos-arm64.tar.gz"
  sha256 "54b8c00f819581087ff505b3fb7fb9c76556abc1b85429cf141509438e1e8d3d"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/CLoaKY233/siltop/releases/download/v1.2.1"
    sha256 cellar: :any_skip_relocation, all: "8600880050a0c4d21253e40ea2aa3ec9b446e85150f08b5ff7b2c8276d2aa352"
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "siltop"
    generate_completions_from_executable(bin/"siltop", "completions")
    (man1/"siltop.1").write Utils.safe_popen_read(bin/"siltop", "man")
    doc.install "README.md", "CHANGELOG.md", "THIRD_PARTY_NOTICES.html"
    prefix.install "LICENSE-MIT", "LICENSE-APACHE"
  end

  def caveats
    <<~EOS
      siltop reads everything it shows without sudo. Its only network request is an
      optional daily update check, off unless you turn it on (onboarding or settings).
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
