cask "goink" do
  version "1.6.1"
  sha256 "a2223e2ecc31702a9b8bfd437a87dbdceb254213a217495e6c8220b08374fdd7"

  url "https://github.com/sigpanic/goink/releases/download/v#{version}/goink-v#{version}-macos-arm64.dmg"
  name "Goink"
  desc "Desktop AI novel-writing system with structured memory"
  homepage "https://github.com/sigpanic/goink"

  livecheck do
    url :url
    strategy :github_latest
  end

  # 上游只出 arm64 DMG
  depends_on arch: :arm64
  depends_on :macos

  app "goink.app"

  zap trash: "~/.goink"

  caveats <<~EOS
    Goink is ad-hoc signed, not notarized. If macOS blocks it, run:
      xattr -dr com.apple.quarantine #{appdir}/goink.app
  EOS
end
