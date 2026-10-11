class Sillytavern < Formula
  desc "LLM frontend for power users"
  homepage "https://sillytavern.app"
  url "https://github.com/SillyTavern/SillyTavern.git",
      tag:      "1.19.0",
      revision: "7e8663cd9c184a550b37238218bdd32c6efc68e9"
  license "AGPL-3.0-only"
  head "https://github.com/SillyTavern/SillyTavern.git", branch: "release"

  depends_on "node"

  def install
    system "npm", "ci", "--omit=dev", "--no-audit", "--no-fund"
    libexec.install Dir["*"]

    # Global mode: config/data 放在使用者目錄，不寫入 libexec
    (bin/"sillytavern").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/src/server-global.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Config and user data are stored in:
        macOS: ~/Library/Application Support/SillyTavern
        Linux: ~/.local/share/SillyTavern
    EOS
  end

  service do
    run [opt_bin/"sillytavern", "--browserLaunchEnabled", "false"]
    keep_alive true
    log_path var/"log/sillytavern.log"
    error_log_path var/"log/sillytavern.log"
  end

  test do
    port = free_port
    pid = spawn bin/"sillytavern", "--port", port.to_s, "--browserLaunchEnabled", "false"
    begin
      # 最多等 60 秒啟動
      output = shell_output("curl -s --retry 60 --retry-delay 1 --retry-connrefused http://127.0.0.1:#{port}/")
      assert_match "SillyTavern", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
