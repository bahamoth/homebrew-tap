class Wimcc < Formula
  desc "What's in My Claude Code — local-only execution inspection with evidence-linked insight"
  homepage "https://github.com/bahamoth/whats-in-my-cc"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.0/wimcc-aarch64-apple-darwin.tar.xz"
      sha256 "25840d92e2fb5adaaba5bb7a4acd720424358499c00c3a2f85615fcb1084b02d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.0/wimcc-x86_64-apple-darwin.tar.xz"
      sha256 "08e2b5be287e179b7c90a6389c66adc570c63c4da832eb7d5a0f47d11f1e8963"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.0/wimcc-aarch64-unknown-linux-musl.tar.xz"
      sha256 "226cec2420d4501a3019d13d5691d86c925add18d2d5a5f7789b43784991d6ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.0/wimcc-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5e361066d90b16a802b84be984abf68db8e45a51a0256685f3b5b4a1daa93c51"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wimcc" if OS.mac? && Hardware::CPU.arm?
    bin.install "wimcc" if OS.mac? && Hardware::CPU.intel?
    bin.install "wimcc" if OS.linux? && Hardware::CPU.arm?
    bin.install "wimcc" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
