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

設定檔在 `$(brew --prefix)/etc/caddy-localdns/`：`Caddyfile` 只負責 import，每個 site 一個 `sites/*.caddy`。改完跑 `brew services restart caddy-localdns`。
用 `*.localhost` 網域，Chrome / Firefox / curl 會自動解析到 127.0.0.1，不用改 `/etc/hosts`（Safari 不一定支援）。
升級只會補上新的 site 檔，不覆蓋已存在的；要停用某個 site 就清空或改掉 `.caddy` 副檔名（直接刪除下次升級會被補回）。
