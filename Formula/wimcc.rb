class Wimcc < Formula
  desc "What's in My Claude Code — local-only execution inspection with evidence-linked insight"
  homepage "https://github.com/bahamoth/whats-in-my-cc"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.4.0/wimcc-aarch64-apple-darwin.tar.xz"
      sha256 "ca48eba9caea024a89558a8ebf676c33ab377bf7a680262924c0b065f69c7268"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.4.0/wimcc-x86_64-apple-darwin.tar.xz"
      sha256 "9b2282460a453808cc4b21c38dddc6ed881611df23882d75f53061091370b410"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.4.0/wimcc-aarch64-unknown-linux-musl.tar.xz"
      sha256 "8fb73dcaaa33bb91fcd4f1edebc6952d019e38941026052b7fadb96945f2591d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bahamoth/whats-in-my-cc/releases/download/v1.4.0/wimcc-x86_64-unknown-linux-musl.tar.xz"
      sha256 "37c4cc04adc0d826ef6fc9f1cd9be2d5d3ea81af4f151cfc29cab2bb2135a029"
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
