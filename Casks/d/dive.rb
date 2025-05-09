cask "dive" do
  version "0.8.4"

  on_arm do
    sha256 "b527740ad05f6faa5987bfbe736ce4cad1bd381263a6df1433fc07274b102f27"

    url "https://github.com/OpenAgentPlatform/Dive/releases/download/v#{version}/Dive-#{version}-mac-arm64.dmg"
  end
  on_intel do
    sha256 "db4629498397dbf20b77d64097a28345cab784667d23e7a47935e38049e48994"

    url "https://github.com/OpenAgentPlatform/Dive/releases/download/v#{version}/Dive-#{version}-mac-x64.dmg"
  end

  name "Dive"
  desc "Desktop application for exploring and analyzing container images"
  homepage "https://github.com/OpenAgentPlatform/Dive"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Dive.app"

  zap trash: [
    "~/Library/Application Support/Dive",
    "~/Library/Preferences/com.openagentplatform.dive.plist",
    "~/Library/Saved Application State/com.openagentplatform.dive.savedState",
  ]
end
