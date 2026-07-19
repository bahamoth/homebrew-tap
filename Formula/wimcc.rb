class Wimcc < Formula
  desc "What's in My Claude Code — local-only execution inspection with evidence-linked insight"
  homepage "https://github.com/bahamoth/whats-in-my-cc"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.5.0/wimcc-aarch64-apple-darwin.tar.xz"
      sha256 "b4167063b9edef02c95493bc5ab006a9946cd6d5718b555c7e3ee71649bc085c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.5.0/wimcc-x86_64-apple-darwin.tar.xz"
      sha256 "14636540d26eac5ace4ea2ae7862c803b74a22ecf71c576884045295148b08e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.5.0/wimcc-aarch64-unknown-linux-musl.tar.xz"
      sha256 "971f6361b746dddfe6ac804f74afd3497d29995483b5da7d276fe289701552eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.5.0/wimcc-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c9aff3098d526d38f9ca5a040e2d50c21bdd60c5c798c857ec5c0fbcb6825440"
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
