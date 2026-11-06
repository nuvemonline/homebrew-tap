# Formula do CLI nuvem.cash para o tap nuvemonline/tap. Fonte deste arquivo: o
# installer/homebrew/publish.sh preenche versão e sha256 de cada release e publica no tap
# (github.com/nuvemonline/homebrew-tap, Formula/nuvemcash.rb).
class Nuvemcash < Formula
  desc "CLI do nuvem.cash: gestão de custos de nuvem pelo terminal e por agentes de IA"
  homepage "https://nuvem.cash/"
  version "0.1.1"

  # Binários assinados (ECDSA) e, no macOS, notarizados; servidos pela api do produto.
  if OS.mac?
    url "https://api.nuvem.cash/cli/download/v#{version}/darwin/arm64"
    sha256 "208453e0fab54a3d28bc28608c9573ad373bc9bd7a85816c26a6918b0e41caf4"
  elsif Hardware::CPU.arm?
    url "https://api.nuvem.cash/cli/download/v#{version}/linux/arm64"
    sha256 "952c90b6ce8de15df6a7a76252502c036909f92524e109bd14b1fd8c5c4c248e"
  else
    url "https://api.nuvem.cash/cli/download/v#{version}/linux/amd64"
    sha256 "bc9dfd90703a0a67a6fd851108085e39aeaa233ba185ef8ee75dc9b7ec3faa48"
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
