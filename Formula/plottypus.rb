# Binary formula. The tarball is the GitHub release asset. The source is not public.
# VERSION and SHA256 must match site/api/_release.ts; site/src/lib/seo/release.test.ts checks it.
class Plottypus < Formula
  desc "Apple Silicon system monitor for the terminal: watts, clocks and temperatures"
  homepage "https://plottypus.com"
  url "https://github.com/CLoaKY233/plottypus/releases/download/v1.0.0/plottypus-v1.0.0-macos-arm64.tar.gz"
  # Brew would scan "64" out of "arm64" in the file name, so the version is explicit.
  version "1.0.0"
  sha256 "89cdc2d1993dde0607d942103f393fb5bda6b38e1666ef96c3534d2c56e59f9b"
  license :cannot_represent

  livecheck do
    url "https://plottypus.com/api/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    root_url "https://github.com/CLoaKY233/plottypus/releases/download/v1.0.0"
    sha256 cellar: :any_skip_relocation, all: "097bdc884789742b8c0fb2dae0587c2b44cfebeef149189ca288212fafeabb74"
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
      plottypus reads everything it shows without sudo and never uses the network.
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
