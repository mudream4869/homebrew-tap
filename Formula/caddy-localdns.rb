class CaddyLocaldns < Formula
  desc "Caddy reverse proxy for local dev domains"
  homepage "https://github.com/mudream4869/homebrew-tap"
  # 只取 tap 裡的 Caddyfile 模板，跟著 main 走
  url "https://github.com/mudream4869/homebrew-tap.git", branch: "main"
  version "1"

  depends_on "caddy"

  def install
    # 已存在時不覆蓋，新版存成 Caddyfile.default
    (etc/"caddy-localdns").install "files/caddy-localdns/Caddyfile"

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
