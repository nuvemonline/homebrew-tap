# Formula do CLI nuvem.cash para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuvemcash.rb).
class Nuvemcash < Formula
  desc "CLI do nuvem.cash: gestão de custos de nuvem pelo terminal e por agentes de IA"
  homepage "https://nuvem.cash/"
  version "0.1.0"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.cash/cli/download/v#{version}/darwin/arm64"
    sha256 "71e3fa564ef72164d27fcb344b2d8483ff8bb07bf471c9d5fec661a854bdbd1a"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.cash/cli/download/v#{version}/linux/arm64"
    sha256 "153acbd553be6f4920003ead07aad847ff0d8f40f958ac8133add1e169720917"
  else
    url "https://api.nuvem.cash/cli/download/v#{version}/linux/amd64"
    sha256 "080f54305f177af7dcacbebe4b9b3f25dfa7526ea36f314676ae3310e0d038df"
  end

  livecheck do
    url "https://api.nuvem.cash/cli/version"
    strategy :json do |json|
      json["version"]&.delete_prefix("v")
    end
  end

  def install
    # O download é o binário cru (sem arquivo compactado), sem o bit de execução.
    binary = Dir["nuvemcash-*"].first
    chmod 0755, binary
    bin.install binary => "nuvemcash"
    generate_completions_from_executable(bin/"nuvemcash", shell_parameter_format: :cobra,
                                                            shells:                 [:bash, :zsh, :fish])
  end

  def caveats
    <<~EOS
      Para atualizar, use `brew upgrade nuvemcash` (o `nuvemcash update` não troca uma instalação do Homebrew).
      Entre com `nuvemcash login` e, para agentes de IA, rode `nuvemcash skill install`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuvemcash --version")
  end
end
