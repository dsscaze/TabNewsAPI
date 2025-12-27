#!/bin/bash
# Script para publicar pacote NuGet no NuGet.org
# Incrementa a versão, faz o pack e o push automaticamente

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para imprimir mensagens
info() { echo -e "${CYAN}$1${NC}"; }
success() { echo -e "${GREEN}$1${NC}"; }
error() { echo -e "${RED}$1${NC}"; }

# Parâmetros
INCREMENT_TYPE="${1:-patch}" # patch, minor ou major
API_KEY="${2:-$NUGET_API_KEY}"

# Caminho do projeto
PROJECT_PATH="TabNewsClientCore/TabNewsClientCore.csproj"
OUTPUT_DIR="TabNewsClientCore/bin/Release"

if [ ! -f "$PROJECT_PATH" ]; then
    error "❌ Arquivo de projeto não encontrado: $PROJECT_PATH"
    exit 1
fi

info "📦 Iniciando processo de publicação do TabNewsClientCore..."
echo ""

# 1. Ler versão atual
info "🔍 Lendo versão atual..."
CURRENT_VERSION=$(grep -oP '<Version>\K[^<]+' "$PROJECT_PATH")

if [ -z "$CURRENT_VERSION" ]; then
    error "❌ Versão não encontrada no arquivo de projeto"
    exit 1
fi

info "   Versão atual: $CURRENT_VERSION"

# 2. Incrementar versão
IFS='.' read -r -a version_parts <<< "$CURRENT_VERSION"
major=${version_parts[0]}
minor=${version_parts[1]}
patch=${version_parts[2]}

case "$INCREMENT_TYPE" in
    major)
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    minor)
        minor=$((minor + 1))
        patch=0
        ;;
    *)
        patch=$((patch + 1))
        ;;
esac

NEW_VERSION="$major.$minor.$patch"
success "   Nova versão: $NEW_VERSION"
echo ""

# 3. Atualizar versão no arquivo .csproj
info "✏️  Atualizando versão no projeto..."
sed -i "s|<Version>$CURRENT_VERSION</Version>|<Version>$NEW_VERSION</Version>|" "$PROJECT_PATH"
success "   ✓ Versão atualizada"
echo ""

# 4. Limpar builds anteriores
info "🧹 Limpando builds anteriores..."
rm -f "$OUTPUT_DIR"/*.nupkg 2>/dev/null || true
dotnet clean "$PROJECT_PATH" -c Release --nologo -v minimal
success "   ✓ Limpeza concluída"
echo ""

# 5. Fazer o pack
info "📦 Criando pacote NuGet..."
dotnet pack "$PROJECT_PATH" -c Release --nologo
success "   ✓ Pacote criado com sucesso"
echo ""

# 6. Encontrar o arquivo .nupkg criado
PACKAGE_FILE=$(find "$OUTPUT_DIR" -name "*.nupkg" -type f | head -n 1)

if [ -z "$PACKAGE_FILE" ]; then
    error "❌ Arquivo .nupkg não encontrado"
    exit 1
fi

info "📄 Pacote gerado: $(basename "$PACKAGE_FILE")"
echo ""

# 7. Fazer o push
if [ -z "$API_KEY" ]; then
    error "❌ API Key não fornecida!"
    echo "   Use: ./publish-nuget.sh patch 'sua-chave'"
    echo "   Ou defina a variável de ambiente NUGET_API_KEY"
    exit 1
fi

info "🚀 Publicando pacote no NuGet.org..."
dotnet nuget push "$PACKAGE_FILE" --api-key "$API_KEY" --source https://api.nuget.org/v3/index.json --skip-duplicate

echo ""
success "✅ Publicação concluída com sucesso!"
success "   Versão: $NEW_VERSION"
success "   Pacote: $(basename "$PACKAGE_FILE")"
echo ""
info "📝 Não esqueça de commitar as alterações:"
echo "   git add ."
echo "   git commit -m 'Bump version to $NEW_VERSION'"
echo "   git tag v$NEW_VERSION"
echo "   git push && git push --tags"
