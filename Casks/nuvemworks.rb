cask "nuvemworks" do
  version :latest
  sha256 :no_check

  url "https://api.nuvem.works/api/desktop/download?asset=macos-universal"
  name "nuvem.works"
  desc "Acesso às áreas de trabalho e aplicações do nuvem.works"
  homepage "https://nuvem.works"

  # O app se atualiza sozinho; o cask só instala.
  auto_updates true
  depends_on macos: ">= :ventura"

  app "nuvem.works.app"
  binary "#{appdir}/nuvem.works.app/Contents/MacOS/nuvemworks"

  # O app ainda não é notarizado pela Apple: sem a quarentena, o Gatekeeper não barra a
  # primeira abertura.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/nuvem.works.app"]
  end

  zap trash: [
    "~/Library/Application Support/nuvemworks",
    "~/Library/Logs/nuvemworks",
  ]
end
