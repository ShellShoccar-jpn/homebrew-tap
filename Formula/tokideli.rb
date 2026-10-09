class Tokideli < Formula
  desc "Collection of lightweight POSIX-compliant commands for accurate time management"
  homepage "https://github.com/ShellShoccar-jpn/tokideli"
  url "https://github.com/ShellShoccar-jpn/tokideli/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9a039c3125ce73337acc1e7d8d7040d235f3fb11838e080ddfc6cc679484e630"
  license "Unlicense"

  def install
    (buildpath/"bin").mkpath
    system "sh", "c_src/MAKE.sh", "-d", "#{buildpath}/bin"
    # "sleep" is installed as "tdsleep": it would otherwise shadow the
    # system's own sleep(1) on $PATH, and the project's AUR package
    # applies the same rename for the same reason (there, pacman flatly
    # refuses to install a file already owned by coreutils).
    bin.install "bin/sleep" => "tdsleep"
    bin.install(Dir["bin/*"] - ["bin/sleep"])
    doc.install Dir["manual/*.md"] - ["manual/CLAUDE.md"]
  end

  def caveats
    <<~EOS
      tokideli's "sleep" command is installed as "tdsleep", since it would
      otherwise shadow your system's own sleep(1) on $PATH.
    EOS
  end

  test do
    assert_match "(tokideli) #{version}", shell_output("#{bin}/tdsleep --version")
  end
end
