class CaddyLocaldns < Formula
  desc "Caddy reverse proxy for local dev domains"
  homepage "https://github.com/mudream4869/homebrew-tap"
  # Homebrew 規定要有 url；內容沒用到，只是 pinned 的小檔
  url "https://raw.githubusercontent.com/caddyserver/caddy/v2.11.7/LICENSE"
  version "2"
  sha256 "cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30"

  depends_on "caddy"

  def install
    # 初始模板；已存在就不動
    (etc/"caddy-localdns").mkpath
    unless (etc/"caddy-localdns/Caddyfile").exist?
      (etc/"caddy-localdns/Caddyfile").write <<~EOS
        http://sillytavern.localhost {
          reverse_proxy localhost:8000
        }
      EOS
    end

    # keg 不能是空的，順便當 service 入口
    (bin/"caddy-localdns").write <<~SH
      #!/bin/sh
      exec "#{Formula["caddy"].opt_bin}/caddy" run --config "#{etc}/caddy-localdns/Caddyfile" "$@"
    SH
  end

  def caveats
    <<~EOS
      Config:
        #{etc}/caddy-localdns/Caddyfile

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
end
