# Script para publicar os dois pacotes NuGet (TabNewsCSharpSDK + TabNewsClientCore) juntos
# Incrementa versão em ambos, faz pack e push automaticamente

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

if (-not $ApiKey) {
    Write-Host "Chave NuGet nao foi fornecida. Use: publish-both-packages.ps1 -ApiKey 'sua-chave'" -ForegroundColor Red
    exit 1
}

# Cores para output
function Write-Info { Write-Host $args -ForegroundColor Cyan }
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Error { Write-Host $args -ForegroundColor Red }

# Caminhos dos projetos
$projectClientCore = "TabNewsClientCore\TabNewsClientCore.csproj"
$projectCSharpSDK = "TabNewsCSharpSDK\TabNewsCSharpSDK.csproj"

# Validar existência dos projetos
if (-not (Test-Path $projectClientCore)) {
    Write-Error "Projeto nao encontrado: $projectClientCore"
    exit 1
}

if (-not (Test-Path $projectCSharpSDK)) {
    Write-Error "Projeto nao encontrado: $projectCSharpSDK"
    exit 1
}

Write-Info "==========================================="
Write-Info "Publicacao de ambos os pacotes NuGet"
Write-Info "==========================================="
Write-Host ""

# ==========================================
# 1. LER VERSOES ATUAIS
# ==========================================
Write-Info "Lendo versoes atuais..."

# TabNewsClientCore (SDK-style)
[xml]$xmlClientCore = Get-Content $projectClientCore -Encoding UTF8
$currentVersionClientCore = $xmlClientCore.Project.PropertyGroup.Version

# TabNewsCSharpSDK (le do .csproj agora)
[xml]$xmlCSharpSDK = Get-Content $projectCSharpSDK -Encoding UTF8
$currentVersionCSharpSDK = $xmlCSharpSDK.Project.PropertyGroup | Where-Object { $_.Version } | Select-Object -First 1 -ExpandProperty Version

if (-not $currentVersionClientCore) {
    Write-Error "Versao nao encontrada no TabNewsClientCore"
    exit 1
}

if (-not $currentVersionCSharpSDK) {
    Write-Error "Versao nao encontrada no TabNewsCSharpSDK"
    exit 1
}

Write-Success "  TabNewsClientCore: $currentVersionClientCore"
Write-Success "  TabNewsCSharpSDK:  $currentVersionCSharpSDK"
Write-Host ""

# Validar que as versoes sao iguais
if ($currentVersionClientCore -ne $currentVersionCSharpSDK) {
    Write-Host "Aviso: As versoes sao diferentes!" -ForegroundColor Yellow
    Write-Host "   TabNewsClientCore: $currentVersionClientCore" -ForegroundColor Yellow
    Write-Host "   TabNewsCSharpSDK:  $currentVersionCSharpSDK" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "Deseja continuar? (s/n)"
    if ($response -ne "s") {
        Write-Info "Operacao cancelada"
        exit 0
    }
}

# ==========================================
# 2. CALCULAR NOVA VERSAO
# ==========================================
Write-Info "Calculando nova versao ($IncrementType)..."

$versionParts = $currentVersionClientCore.Split(".")
[int]$major = $versionParts[0]
[int]$minor = $versionParts[1]
[int]$patch = $versionParts[2]

switch ($IncrementType.ToLower()) {
    "major" { $major++; $minor = 0; $patch = 0 }
    "minor" { $minor++; $patch = 0 }
    "patch" { $patch++ }
    default { 
        Write-Error "IncrementType invalido. Use: major, minor ou patch"
        exit 1
    }
}

$newVersion = "$major.$minor.$patch"
Write-Success "Nova versao: $newVersion"
Write-Host ""

# ==========================================
# 3. ATUALIZAR VERSOES NOS PROJETOS
# ==========================================
Write-Info "Atualizando versao nos arquivos de projeto..."

# TabNewsClientCore
$xmlClientCore.Project.PropertyGroup.Version = $newVersion
$utf8BOM = New-Object System.Text.UTF8Encoding $true
$writer = New-Object System.IO.StreamWriter((Resolve-Path $projectClientCore), $false, $utf8BOM)
$xmlClientCore.Save($writer)
$writer.Close()
Write-Success "  TabNewsClientCore atualizado para $newVersion"

# TabNewsCSharpSDK - atualizar versao no .csproj
$foundSDK = $false
foreach ($pg in $xmlCSharpSDK.Project.PropertyGroup) {
    if ($null -ne $pg.Version) {
        $pg.Version = $newVersion
        $foundSDK = $true
        break
    }
}

if (-not $foundSDK) {
    Write-Host "Erro: Nao foi possivel encontrar Version no TabNewsCSharpSDK.csproj" -ForegroundColor Red
    exit 1
}

$writer = New-Object System.IO.StreamWriter((Resolve-Path $projectCSharpSDK), $false, $utf8BOM)
$xmlCSharpSDK.Save($writer)
$writer.Close()
Write-Success "  TabNewsCSharpSDK atualizado para $newVersion"
Write-Host ""

# ==========================================
# 5. CRIAR PACOTES
# ==========================================
Write-Info "Criando pacotes NuGet..."

try {
    Write-Info "  Criando pacote TabNewsClientCore..."
    dotnet pack $projectClientCore -c Release --no-build | Out-Null
    Write-Success "    Pacote criado"
    
    Write-Info "  Criando pacote TabNewsCSharpSDK..."
    dotnet pack $projectCSharpSDK -c Release --no-build | Out-Null
    Write-Success "    Pacote criado"
}
catch {
    Write-Error "Erro ao criar pacotes: $_"
    exit 1
}

Write-Host ""

# ==========================================
# 6. PUBLICAR NO NUGET
# ==========================================
Write-Info "Publicando pacotes no NuGet.org..."

$packageClientCore = Get-ChildItem "TabNewsClientCore\bin\Release\TabNewsClientCore.$newVersion.nupkg" -ErrorAction SilentlyContinue
$packageCSharpSDK = Get-ChildItem "TabNewsCSharpSDK\bin\Release\TabNewsCSharpSDK.$newVersion.nupkg" -ErrorAction SilentlyContinue

$pushedCount = 0

if ($packageClientCore) {
    Write-Info "  Publicando TabNewsClientCore..."
    try {
        dotnet nuget push $packageClientCore.FullName --api-key $ApiKey --source https://api.nuget.org/v3/index.json
        Write-Success "    Publicado com sucesso!"
        $pushedCount++
    }
    catch {
        Write-Host "    Erro ao publicar TabNewsClientCore: $_" -ForegroundColor Red
    }
}
else {
    Write-Host "    Aviso: Pacote nao encontrado: TabNewsClientCore.$newVersion.nupkg" -ForegroundColor Yellow
}

if ($packageCSharpSDK) {
    Write-Info "  Publicando TabNewsCSharpSDK..."
    try {
        dotnet nuget push $packageCSharpSDK.FullName --api-key $ApiKey --source https://api.nuget.org/v3/index.json
        Write-Success "    Publicado com sucesso!"
        $pushedCount++
    }
    catch {
        Write-Host "    Erro ao publicar TabNewsCSharpSDK: $_" -ForegroundColor Red
    }
}
else {
    Write-Host "    Aviso: Pacote nao encontrado: TabNewsCSharpSDK.$newVersion.nupkg" -ForegroundColor Yellow
}

Write-Host ""

# ==========================================
# 7. COMMIT E TAG
# ==========================================
if ($pushedCount -eq 2) {
    Write-Info "Criando commit e tag no Git..."
    try {
        git add $projectClientCore $nuspecPath
        git commit -m "Bump version to $newVersion - publicacao dos dois pacotes"
        git tag "v$newVersion"
        Write-Success "  Commit e tag criados"
    }
    catch {
        Write-Host "    Aviso: Erro ao fazer commit: $_" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Success "==========================================="
    Write-Success "Publicacao concluida com sucesso!"
    Write-Success "Versao: $newVersion"
    Write-Success "==========================================="
}
else {
    Write-Host ""projectCSharpSDK
    Write-Host "===========================================" -ForegroundColor Red
    $mensagem = "Publicacao incompleta ($pushedCount de 2 pacotes)"
    Write-Host $mensagem -ForegroundColor Red
    Write-Host "===========================================" -ForegroundColor Red
    exit 1
}