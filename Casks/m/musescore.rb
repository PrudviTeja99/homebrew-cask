cask "musescore" do
  arch arm: "aarch64", intel: "x86_64"
  url_end = on_system_conditional macos: ".dmg", linux: "-#{arch}.AppImage"

  version "4.7.4.260706075,4.7.4"

  on_macos do
    sha256 "e3596e27da0806a3384cab67d52f8478ad21ed2bd6fc96d7cb874d840b016fac"

    app "MuseScore #{version.major}.app"
    command_wrapper "mscore",
                    executable: "#{appdir}/MuseScore #{version.major}.app/Contents/MacOS/mscore"

    zap trash: [
      "~/Library/Application Support/MuseScore",
      "~/Library/Caches/MuseScore",
      "~/Library/Caches/org.musescore.MuseScore",
      "~/Library/Preferences/org.musescore.MuseScore*.plist",
      "~/Library/Saved Application State/org.musescore.MuseScore.savedState",
    ]
  end
  on_linux do
    sha256 arm64_linux:  "162ae55b317660f196b2e73d566bdb45c1e990ed4cc140709d25d97b9ef366b0",
           x86_64_linux: "9233ed1b87d3e6b45722278f3c286dcd41e83da778bd0f80a1dd04949696ad93"

    app_image "MuseScore-Studio-#{version.csv.first}-#{arch}.AppImage", target: "MuseScore.AppImage"

    zap trash: [
      "~/.config/MuseScore",
      "~/.local/share/data/MuseScore",
      "~/.local/share/MuseScore",
    ]
  end

  url "https://github.com/musescore/MuseScore/releases/download/v#{version.csv.second}/MuseScore-Studio-#{version.csv.first}#{url_end}"
  name "MuseScore"
  desc "Open-source music notation software"
  homepage "https://musescore.org/"

  livecheck do
    url :url
    regex(%r{/v?(\d+(?:\.\d+)+)/MuseScore[._-]Studio[._-]v?(\d+(?:\.\d+)+)\.dmg}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[2]},#{match[1]}"
      end
    end
  end

  auto_updates true
end
