# Formula do CLI nuvem.insure para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuveminsure.rb).
class Nuveminsure < Formula
  desc "CLI do nuvem.insure: backup centralizado pelo terminal e por agentes de IA"
  homepage "https://nuvem.insure/"
  version "0.6.0"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.insure/cli/download/v#{version}/darwin/arm64"
    sha256 "fa6de412699e690a12d864aacff9ccad8ae9a230fa99da50d3a99ba21fc09128"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/arm64"
    sha256 "c26f474e45939cb4e645cf5ca879f7e645f9e48cec8bea9abf5ae6778dfe2860"
  else
    url "https://api.nuvem.insure/cli/download/v#{version}/linux/amd64"
    sha256 "4b568a71004d090d8fcfc286ea06d3b035e7eea24b8f8228d91ba4f6e1814eed"
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
