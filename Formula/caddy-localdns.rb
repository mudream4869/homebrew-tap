class CaddyLocaldns < Formula
  desc "Caddy reverse proxy for local dev domains"
  homepage "https://github.com/mudream4869/homebrew-tap"
  # Homebrew 規定要有 url；內容沒用到，只是 pinned 的小檔
  url "https://raw.githubusercontent.com/caddyserver/caddy/v2.11.7/LICENSE"
  version "2"
  sha256 "cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30"

  depends_on "caddy"

  def install
    conf = etc/"caddy-localdns"
    (conf/"sites").mkpath

    write_default conf/"Caddyfile", <<~EOS
      import #{conf}/sites/*.caddy
    EOS

    # 新 service：加一個 site 檔並 bump version
    write_default conf/"sites/sillytavern.caddy", <<~EOS
      http://sillytavern.localhost {
        reverse_proxy localhost:8000
      }
    EOS

    # keg 不能是空的，順便當 service 入口
    (bin/"caddy-localdns").write <<~SH
      #!/bin/sh
      exec "#{Formula["caddy"].opt_bin}/caddy" run --config "#{conf}/Caddyfile" "$@"
    SH
  end

  def caveats
    <<~EOS
      Config:
        #{etc}/caddy-localdns/Caddyfile
        #{etc}/caddy-localdns/sites/*.caddy  (one file per site)

      Upgrades add new site files but never overwrite existing ones.
      To disable a site, empty its file or rename it away from *.caddy;
      deleting it brings it back on the next upgrade.

      Upgrading from version 1? Your old Caddyfile is kept; replace its
      contents with this line (keeping both duplicates sillytavern):
        import #{etc}/caddy-localdns/sites/*.caddy

      Use *.localhost domains (e.g. sillytavern.localhost); browsers resolve
      them to 127.0.0.1 without editing /etc/hosts.

      Apply config changes:
        brew services restart caddy-localdns

      Don't run alongside `brew services start caddy`; both bind :80/:443 and :2019.
    EOS
  end

  service do
    run opt_bin/"caddy-localdns"
    keep_alive true
    log_path var/"log/caddy-localdns.log"
    error_log_path var/"log/caddy-localdns.log"
  end

  test do
    system Formula["caddy"].opt_bin/"caddy", "validate", "--config", etc/"caddy-localdns/Caddyfile"
  end

  private

  # 已存在就不覆蓋
  def write_default(path, content)
    path.write(content) unless path.exist?
  end
end
