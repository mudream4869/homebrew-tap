class Yzma < Formula
  desc "CLI to install llama.cpp libraries and models for yzma"
  homepage "https://yzma.ai"
  url "https://github.com/hybridgroup/yzma.git",
      tag:      "v1.29.1",
      revision: "aaba522c583d42a035e58b0f6bf77ca71496dcef"
  license "Apache-2.0"
  head "https://github.com/hybridgroup/yzma.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      Install the llama.cpp libraries, then point YZMA_LIB at them:
        yzma install --lib ~/yzma-lib
        export YZMA_LIB=~/yzma-lib
    EOS
  end

  test do
    assert_match "yzma version #{version}", shell_output("#{bin}/yzma version")
  end
end
