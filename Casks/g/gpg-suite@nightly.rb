cask "gpg-suite@nightly" do
  version "3590n"
  sha256 "67389ee89c8c0b02bbcadca542e36151a3c61276b58d546b928e26f54102983c"

  url "https://releases.gpgtools.org/nightlies/GPG_Suite-#{version}.dmg"
  name "GPG Suite Nightly"
  desc "Tools to protect your emails and files"
  homepage "https://gpgtools.org/"

  livecheck do
    url "https://releases.gpgtools.org/nightlies/"
    regex(/href=.*?GPG[._-]Suite[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d*)?)\.dmg/i)
  end

  auto_updates true
  conflicts_with cask: [
    "gpg-suite",
    "gpg-suite-no-mail",
    "gpg-suite-pinentry",
  ], formula: "gnupg"
  depends_on macos: ">= :mojave"

  pkg "Install.pkg"

  uninstall_postflight do
    ["gpg", "gpg2", "gpg-agent"].map { |exec_name| Pathname("/usr/local/bin")/exec_name }.each do |exec|
      exec.unlink if exec.exist? && exec.readlink.to_s.include?("MacGPG2")
    end
  end

  uninstall launchctl: [
              "org.gpgtools.gpgmail.enable-bundles",
              "org.gpgtools.gpgmail.patch-uuid-user",
              "org.gpgtools.gpgmail.user-uuid-patcher",
              "org.gpgtools.gpgmail.uuid-patcher",
              "org.gpgtools.Libmacgpg.xpc",
              "org.gpgtools.macgpg2.fix",
              "org.gpgtools.macgpg2.gpg-agent",
              "org.gpgtools.macgpg2.shutdown-gpg-agent",
              "org.gpgtools.macgpg2.updater",
              "org.gpgtools.updater",
            ],
            quit:      [
              "com.apple.mail",
              "org.gpgtools.gpgkeychain",
              "org.gpgtools.gpgkeychainaccess",
              "org.gpgtools.gpgmail.upgrader",
              "org.gpgtools.gpgservices",
              # TODO: add "killall -kill gpg-agent"
            ],
            script:    {
              executable: "#{staged_path}/Uninstall.app/Contents/Resources/GPG Suite Uninstaller.app/Contents/Resources/uninstall.sh",
              sudo:       true,
            },
            pkgutil:   "org.gpgtools.*",
            delete:    [
              "/Library/Application Support/GPGTools",
              "/Library/Frameworks/Libmacgpg.framework",
              "/Library/Mail/Bundles.gpgmail*",
              "/Library/Mail/Bundles/GPGMail.mailbundle",
              "/Library/PreferencePanes/GPGPreferences.prefPane",
              "/Library/Services/GPGServices.service",
              "/Network/Library/Mail/Bundles/GPGMail.mailbundle",
              "/private/etc/manpaths.d/MacGPG2",
              "/private/etc/paths.d/MacGPG2",
              "/private/tmp/gpg-agent",
              "/usr/local/MacGPG2",
            ]

  zap trash: [
    "~/Library/Application Support/GPGTools",
    "~/Library/Caches/org.gpgtools.gpg*",
    "~/Library/Containers/com.apple.mail/Data/Library/Frameworks/Libmacgpg.framework",
    "~/Library/Containers/com.apple.mail/Data/Library/Preferences/org.gpgtools.*",
    "~/Library/Frameworks/Libmacgpg.framework",
    "~/Library/HTTPStorages/org.gpgtools.*",
    "~/Library/LaunchAgents/org.gpgtools.*",
    "~/Library/Mail/Bundles/GPGMail.mailbundle",
    "~/Library/PreferencePanes/GPGPreferences.prefPane",
    "~/Library/Preferences/org.gpgtools.*",
    "~/Library/Services/GPGServices.service",
  ]

  caveats do
    files_in_usr_local
  end
end
