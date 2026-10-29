# Formula do CLI nuvem.insure para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuveminsure.rb).
class Nuveminsure < Formula
  desc "CLI do nuvem.insure: backup centralizado pelo terminal e por agentes de IA"
  homepage "https://nuvem.insure/"
  version "0.2.1"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.insure/cli/download/v#{version}/darwin/arm64"
    sha256 "0d606562acced2227a60ce78badb5748880c8ca8bcf6a54ab7d61e062a3d724f"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/arm64"
    sha256 "f56838e715cf70245a2c1fa8e2087c53d03337333a0a86d0018225c950bbb426"
  else
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/amd64"
    sha256 "8b9e5d3365cb349c957b8b6871af4bec78c45b820ff0f3e618a1bb9a9ab40d85"
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
