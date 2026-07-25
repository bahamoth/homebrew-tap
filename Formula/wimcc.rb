class Wimcc < Formula
  desc "What's in My Claude Code — local-only execution inspection with evidence-linked insight"
  homepage "https://github.com/bahamoth/whats-in-my-cc"
  version "1.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.1/wimcc-aarch64-apple-darwin.tar.xz"
      sha256 "edbcf9f2780f522d9cb75304e6ef7e3bdd5bb08dcc53174f8bf383b3a8b94a58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.1/wimcc-x86_64-apple-darwin.tar.xz"
      sha256 "67df7d3fbfd56bb8ed4c023d08068fb24d69907aa929f68a57e9626f67367cfc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.1/wimcc-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d6b2716a3028936115adb97bf02b0aa9a4203832f4026c231aa84773a1254523"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.6.1/wimcc-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7cf4c1da0e5cf1adfd01e7b7d576aef6b24b62555178cf50b1ee0d4b98f81f05"
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
