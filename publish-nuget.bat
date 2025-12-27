@echo off
REM Script para publicar pacote NuGet no NuGet.org
REM Incrementa a versão, faz o pack e o push automaticamente

setlocal enabledelayedexpansion

set INCREMENT_TYPE=%1
if "%INCREMENT_TYPE%"=="" set INCREMENT_TYPE=patch

set API_KEY=%2
if "%API_KEY%"=="" set API_KEY=%NUGET_API_KEY%

set PROJECT_PATH=TabNewsClientCore\TabNewsClientCore.csproj
set OUTPUT_DIR=TabNewsClientCore\bin\Release

if not exist "%PROJECT_PATH%" (
    echo [ERRO] Arquivo de projeto nao encontrado: %PROJECT_PATH%
    exit /b 1
)

echo.
echo ================================================
echo Publicacao do TabNewsClientCore no NuGet.org
echo ================================================
echo.

REM 1. Ler versão atual
echo [1/7] Lendo versao atual...
for /f "tokens=2 delims=<>" %%a in ('findstr /r "<Version>" "%PROJECT_PATH%"') do set CURRENT_VERSION=%%a

if "%CURRENT_VERSION%"=="" (
    echo [ERRO] Versao nao encontrada no arquivo de projeto
    exit /b 1
)

echo       Versao atual: %CURRENT_VERSION%

REM 2. Incrementar versão
for /f "tokens=1-3 delims=." %%a in ("%CURRENT_VERSION%") do (
    set major=%%a
    set minor=%%b
    set patch=%%c
)

if /i "%INCREMENT_TYPE%"=="major" (
    set /a major+=1
    set minor=0
    set patch=0
) else if /i "%INCREMENT_TYPE%"=="minor" (
    set /a minor+=1
    set patch=0
) else (
    set /a patch+=1
)

set NEW_VERSION=%major%.%minor%.%patch%
echo       Nova versao: %NEW_VERSION%
echo.

REM 3. Atualizar versão no arquivo .csproj
echo [2/7] Atualizando versao no projeto...
powershell -Command "(Get-Content '%PROJECT_PATH%') -replace '<Version>%CURRENT_VERSION%</Version>', '<Version>%NEW_VERSION%</Version>' | Set-Content '%PROJECT_PATH%'"
echo       OK - Versao atualizada
echo.

REM 4. Limpar builds anteriores
echo [3/7] Limpando builds anteriores...
if exist "%OUTPUT_DIR%\*.nupkg" del /q "%OUTPUT_DIR%\*.nupkg"
dotnet clean "%PROJECT_PATH%" -c Release --nologo -v minimal >nul
echo       OK - Limpeza concluida
echo.

REM 5. Fazer o pack
echo [4/7] Criando pacote NuGet...
dotnet pack "%PROJECT_PATH%" -c Release --nologo
if errorlevel 1 (
    echo [ERRO] Falha ao criar pacote
    exit /b 1
)
echo       OK - Pacote criado
echo.

REM 6. Encontrar o arquivo .nupkg criado
echo [5/7] Localizando pacote gerado...
for %%f in ("%OUTPUT_DIR%\*.nupkg") do set PACKAGE_FILE=%%f

if not exist "%PACKAGE_FILE%" (
    echo [ERRO] Arquivo .nupkg nao encontrado
    exit /b 1
)

echo       Pacote: %PACKAGE_FILE%
echo.

REM 7. Verificar API Key
echo [6/7] Verificando credenciais...
if "%API_KEY%"=="" (
    echo [ERRO] API Key nao fornecida!
    echo.
    echo Use: publish-nuget.bat patch sua-chave
    echo Ou defina a variavel de ambiente NUGET_API_KEY
    exit /b 1
)
echo       OK - API Key configurada
echo.

REM 8. Fazer o push
echo [7/7] Publicando pacote no NuGet.org...
dotnet nuget push "%PACKAGE_FILE%" --api-key %API_KEY% --source https://api.nuget.org/v3/index.json --skip-duplicate

if errorlevel 1 (
    echo.
    echo [ERRO] Falha ao publicar pacote
    exit /b 1
)

echo.
echo ================================================
echo          PUBLICACAO CONCLUIDA!
echo ================================================
echo.
echo Versao: %NEW_VERSION%
echo Pacote: %PACKAGE_FILE%
echo.
echo Nao esqueca de commitar as alteracoes:
echo   git add .
echo   git commit -m "Bump version to %NEW_VERSION%"
echo   git tag v%NEW_VERSION%
echo   git push ^&^& git push --tags
echo.

endlocal
