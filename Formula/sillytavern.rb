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
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/src/server-global.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      Config and user data are stored in:
        macOS: ~/Library/Application Support/SillyTavern
        Linux: ~/.local/share/SillyTavern
    EOS
  end

  test do
    port = free_port
    pid = spawn bin/"sillytavern", "--port", port.to_s, "--browserLaunchEnabled", "false"
    begin
      sleep 60
      assert_match "SillyTavern", shell_output("curl -s http://127.0.0.1:#{port}/")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
