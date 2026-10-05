# homebrew-tap
Just personal used tap. Don't depend on it.

## Formulae

### sillytavern

```sh
brew install mudream4869/tap/sillytavern
sillytavern                      # 前景執行，http://127.0.0.1:8000
brew services start sillytavern  # 背景服務
```

### caddy-localdns

用 Caddy 把本地網域（例如 `sillytavern.localhost`）反向代理到 localhost port。

```sh
brew install mudream4869/tap/caddy-localdns
brew services start caddy-localdns  # http://sillytavern.localhost -> localhost:8000
```

設定檔在 `$(brew --prefix)/etc/caddy-localdns/Caddyfile`，改完跑 `brew services restart caddy-localdns`。
用 `*.localhost` 網域，Chrome / Firefox / curl 會自動解析到 127.0.0.1，不用改 `/etc/hosts`（Safari 不一定支援）。
初次安裝會寫入預設設定，升級不會覆蓋已存在的 Caddyfile。
