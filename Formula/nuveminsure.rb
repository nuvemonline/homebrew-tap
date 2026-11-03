# Formula do CLI nuvem.insure para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuveminsure.rb).
class Nuveminsure < Formula
  desc "CLI do nuvem.insure: backup centralizado pelo terminal e por agentes de IA"
  homepage "https://nuvem.insure/"
  version "0.5.0"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.insure/cli/download/v#{version}/darwin/arm64"
    sha256 "c047f5a27e1773942a0f311ff63e628d3cf34d8a51aab206ee531b0f1a7379a8"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/arm64"
    sha256 "fb92a148633234de7b0f7cbc6aa76e66294299e8a6682b65cf633490cda195b3"
  else
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/amd64"
    sha256 "78994dc5feec719cdd338ef368c4cbf55da22c5ce3ed2ff5b13ccd91a7d72232"
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
