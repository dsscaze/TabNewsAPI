# Script para publicar pacote NuGet no NuGet.org
# Incrementa a versao, faz o pack e o push automaticamente

param(
    [string]$IncrementType = "patch",
    [string]$ApiKey
)

$ErrorActionPreference = "Stop"

# Se ApiKey nao foi passada como parametro, tentar ler do arquivo
if (-not $ApiKey) {
    $configFile = Join-Path $PSScriptRoot "nugetApiKey.json"
    if (Test-Path $configFile) {
        try {
            $config = Get-Content $configFile -Raw | ConvertFrom-Json
            $ApiKey = $config.apiKey
        }
        catch {
            Write-Warning "Erro ao ler arquivo de configuracao: $_"
        }
    }
}

# Cores para output
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }

# Caminho do projeto
$projectPath = "TabNewsClientCore\TabNewsClientCore.csproj"
$outputDir = "TabNewsClientCore\bin\Release"

if (-not (Test-Path $projectPath)) {
    Write-Error "Arquivo de projeto nao encontrado: $projectPath"
    exit 1
}

Write-Info "Iniciando processo de publicacao do TabNewsClientCore..."
Write-Host ""

# 1. Ler versao atual
Write-Info "Lendo versao atual..."
[xml]$projectXml = Get-Content $projectPath
$currentVersion = $projectXml.Project.PropertyGroup.Version

if (-not $currentVersion) {
    Write-Error "Versao nao encontrada no arquivo de projeto"
    exit 1
}

Write-Info "   Versao atual: $currentVersion"

# 2. Incrementar versao
$versionParts = $currentVersion.Split('.')
$major = [int]$versionParts[0]
$minor = [int]$versionParts[1]
$patch = [int]$versionParts[2]

switch ($IncrementType.ToLower()) {
    "major" {
        $major++
        $minor = 0
        $patch = 0
    }
    "minor" {
        $minor++
        $patch = 0
    }
    default {
        $patch++
    }
}

$newVersion = "$major.$minor.$patch"
Write-Success "   Nova versao: $newVersion"
Write-Host ""

# 3. Atualizar versao no arquivo .csproj
Write-Info "Atualizando versao no projeto..."
$projectXml.Project.PropertyGroup.Version = $newVersion

# Salvar com UTF-8 BOM para preservar acentos
$utf8BOM = New-Object System.Text.UTF8Encoding $true
$writer = New-Object System.IO.StreamWriter((Resolve-Path $projectPath), $false, $utf8BOM)
$projectXml.Save($writer)
$writer.Close()

Write-Success "   Versao atualizada"
Write-Host ""

# 4. Limpar builds anteriores
Write-Info "Limpando builds anteriores..."
if (Test-Path $outputDir) {
    Remove-Item "$outputDir\*.nupkg" -Force -ErrorAction SilentlyContinue
}
dotnet clean $projectPath -c Release --nologo -v minimal
Write-Success "   Limpeza concluida"
Write-Host ""

# 5. Fazer o pack
Write-Info "Criando pacote NuGet..."
dotnet pack $projectPath -c Release --nologo
if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao criar pacote"
    exit 1
}
Write-Success "   Pacote criado com sucesso"
Write-Host ""

# 6. Encontrar o arquivo .nupkg criado
$packageFile = Get-ChildItem "$outputDir\*.nupkg" | Select-Object -First 1

if (-not $packageFile) {
    Write-Error "Arquivo .nupkg nao encontrado"
    exit 1
}

Write-Info "Pacote gerado: $($packageFile.Name)"
Write-Host ""

# 7. Fazer o push
if (-not $ApiKey) {
    Write-Error "API Key nao fornecida!"
    Write-Host ""
    Write-Host "Crie um arquivo 'nugetApiKey.json' na raiz do projeto com:"
    Write-Host '  { "apiKey": "sua-chave-aqui" }'
    Write-Host ""
    Write-Host "Ou passe como parametro:"
    Write-Host "  .\publish-nuget.ps1 -ApiKey 'sua-chave'"
    Write-Host ""
    exit 1
}

Write-Info "Publicando pacote no NuGet.org..."
dotnet nuget push $packageFile.FullName --api-key $ApiKey --source https://api.nuget.org/v3/index.json --skip-duplicate

if ($LASTEXITCODE -ne 0) {
    Write-Error "Erro ao publicar pacote"
    exit 1
}

Write-Host ""
Write-Success "Publicacao concluida com sucesso!"
Write-Success "   Versao: $newVersion"
Write-Success "   Pacote: $($packageFile.Name)"
Write-Host ""
Write-Info "Nao esqueca de commitar as alteracoes:"
Write-Host "   git add ."
Write-Host "   git commit -m 'Bump version to $newVersion'"
Write-Host "   git tag v$newVersion"
Write-Host "   git push; git push --tags"
