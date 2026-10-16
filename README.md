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
會一起安裝它代理的 service（目前是 sillytavern），但 service 要各自啟動。

```sh
brew install mudream4869/tap/caddy-localdns  # 連同 sillytavern 一起裝
brew services start sillytavern
brew services start caddy-localdns  # http://sillytavern.localhost -> localhost:8000
```

設定檔在 `$(brew --prefix)/etc/caddy-localdns/`：`Caddyfile` 只負責 import，每個 site 一個 `sites/*.caddy`。改完跑 `brew services restart caddy-localdns`。
用 `*.localhost` 網域，Chrome / Firefox / curl 會自動解析到 127.0.0.1，不用改 `/etc/hosts`（Safari 不一定支援）。
升級只會補上新的 site 檔，不覆蓋已存在的；要停用某個 site 就清空或改掉 `.caddy` 副檔名（直接刪除下次升級會被補回）。

### yzma

[yzma](https://github.com/hybridgroup/yzma) CLI，下載 llama.cpp 函式庫與 GGUF 模型。

```sh
brew install mudream4869/tap/yzma
yzma install --lib ~/yzma-lib
export YZMA_LIB=~/yzma-lib
```

## Casks

### goink

[Goink](https://github.com/sigpanic/goink) AI 小說寫作桌面 app（僅 Apple Silicon）。

```sh
brew install --cask mudream4869/tap/goink
```

未經 notarize，安裝時會自動移除 quarantine。舊版裝的若仍被 Gatekeeper 擋：`brew reinstall --cask mudream4869/tap/goink` 或 `xattr -dr com.apple.quarantine /Applications/goink.app`。
