# Cask do nuvem.team para o tap nuvemonline/tap (D173). Fonte deste arquivo; quem publica no tap
# (github.com/nuvemonline/homebrew-tap, Casks/nuvemteam.rb) é uma etapa à parte do release.
cask "nuvemteam" do
  version :latest
  sha256 :no_check

  url "https://api.nuvem.team/api/v1/desktop/download?asset=macos-universal"
  name "nuvem.team"
  desc "Plantão, alertas e resposta a incidentes do nuvem.team"
  homepage "https://nuvem.team/"

  # O app se atualiza sozinho (version :latest: o brew não o reinstala a cada upgrade).
  depends_on macos: :ventura

  # Assinado com o Developer ID e notarizado (app#9): o Gatekeeper abre sem passo manual.
  app "nuvem.team.app"

  zap trash: [
    "~/Library/Application Support/nuvemteam",
    "~/Library/Logs/nuvemteam.log",
    "~/Library/Preferences/team.nuvem.desktop.plist",
  ]
end
