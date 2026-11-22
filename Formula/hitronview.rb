class Hitronview < Formula
  desc "Web page listing devices connected to a Hitron router, with MAC aliases"
  homepage "https://github.com/mudream4869/hitronview"
  url "https://github.com/mudream4869/hitronview/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "effbce181a5397b66ff0febde38fdbf22fb2d252190fa71a47b8c0d796caf206"
  license "MIT"
  head "https://github.com/mudream4869/hitronview.git", branch: "main"

  depends_on "go" => :build

  def install
    # 只裝 hitronview；hitronclient 是開發用的除錯工具
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/hitronview"
  end

  def caveats
    <<~EOS
      Create the config (~/.config/hitronview/config.yaml) and edit it:
        hitronview init

      Store the router password in the Keychain (prompts, nothing echoed):
        security add-generic-password -s hitronview -a admin -U -w

      Start it in the background (http://127.0.0.1:18080 by default):
        brew services start hitronview

      macOS asks for Local Network access on first run; allow hitronview in
      System Settings > Privacy & Security > Local Network. Upgrades may ask again.

      hitronview has no login. Keep server.host on 127.0.0.1 and use
      `tailscale serve` (not funnel) for remote access.
    EOS
  end

  service do
    run opt_bin/"hitronview"
    keep_alive true
    log_path var/"log/hitronview.log"
    error_log_path var/"log/hitronview.log"
  end

  test do
    assert_match "hitronview #{version}", shell_output("#{bin}/hitronview -version")

    system bin/"hitronview", "init", "-config", testpath/"config.yaml"
    assert_match "hitron_host:", (testpath/"config.yaml").read
    # 不覆蓋已存在的設定檔
    assert_match "already exists", shell_output("#{bin}/hitronview init -config #{testpath}/config.yaml 2>&1", 1)
  end
end
