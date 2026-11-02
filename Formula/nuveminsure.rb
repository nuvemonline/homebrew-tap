# Formula do CLI nuvem.insure para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuveminsure.rb).
class Nuveminsure < Formula
  desc "CLI do nuvem.insure: backup centralizado pelo terminal e por agentes de IA"
  homepage "https://nuvem.insure/"
  version "0.4.0"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.insure/cli/download/v#{version}/darwin/arm64"
    sha256 "e4590b76db12185063a87132d82ddfcd60407810bd201edc2bce7dcf4b655507"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/arm64"
    sha256 "1df82e44748d5b7cd91fd6447cd6385d83f2a7958e98edba7c8a3df74ac12ed5"
  else
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/amd64"
    sha256 "b53d9240bc445098d6446d02ad4a5ed0de01efb569544e027d66efe8f945329f"
  end

  livecheck do
    url "https://api.nuvem.insure/cli/version"
    strategy :json do |json|
      json["version"]&.delete_prefix("v")
    end
  end

  def install
    # O download é o binário cru (sem arquivo compactado), sem o bit de execução.
    binary = Dir["nuveminsure-*"].first
    chmod 0755, binary
    bin.install binary => "nuveminsure"
    generate_completions_from_executable(bin/"nuveminsure", shell_parameter_format: :cobra,
                                                            shells:                 [:bash, :zsh, :fish])
  end

  def caveats
    <<~EOS
      Para atualizar, use `brew upgrade nuveminsure` (o `nuveminsure update` não troca uma instalação do Homebrew).
      Entre com `nuveminsure login` e, para agentes de IA, rode `nuveminsure skill install`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuveminsure --version")
  end
end
