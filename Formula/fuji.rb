class Fuji < Formula
  desc "A network file system mount manager with daemon-based architecture"
  homepage "https://github.com/DoomedRamen/fuji"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/DoomedRamen/fuji/releases/download/v0.1.3/fuji-aarch64-apple-darwin.tar.xz"
      sha256 "cd37db735dc700999a6b35864384e83506480485012c8d61ff74096d342af198"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DoomedRamen/fuji/releases/download/v0.1.3/fuji-x86_64-apple-darwin.tar.xz"
      sha256 "15129e5a49d24945bcf1b8170c6ff8ff9291649325e019f9a7b57ac13a23c452"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/DoomedRamen/fuji/releases/download/v0.1.3/fuji-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d95d3e6037ae5263a94b975969f22d012688eb8de28212a01ef32bb78f447b36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/DoomedRamen/fuji/releases/download/v0.1.3/fuji-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e070191c836667bc3546bfe530ebadbc9cb8304503f186c577be492db4ffb6d"
    end
  end
  license "ISC"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "fuji" if OS.mac? && Hardware::CPU.arm?
    bin.install "fuji" if OS.mac? && Hardware::CPU.intel?
    bin.install "fuji" if OS.linux? && Hardware::CPU.arm?
    bin.install "fuji" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
