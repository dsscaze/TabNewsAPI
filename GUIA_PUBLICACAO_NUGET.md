# 📤 Guia de Publicação - TabNewsClientCore no NuGet

## 📋 Pré-requisitos

- ✅ Projeto `TabNewsClientCore` criado e compilado
- ✅ NuGet CLI instalado (vem com .NET SDK)
- ✅ Conta no [NuGet.org](https://www.nuget.org)
- ✅ API Key gerada no NuGet.org

---

## 🔑 Passo 1: Obter API Key do NuGet.org

### 1.1 Acessar NuGet.org
1. Vá para [https://www.nuget.org](https://www.nuget.org)
2. Clique em **Sign in** (canto superior direito)
3. Faça login com sua conta

### 1.2 Gerar API Key
1. Clique no nome de usuário > **API keys**
2. Clique em **Create** (ou **+ Create new key**)
3. Configure:
   - **Key Name**: `TabNewsClientCore` (ou seu nome)
   - **Glob Pattern**: `TabNewsClientCore*` (para segurança)
   - **Select Scopes**: Selecione `Push new packages and package versions`
4. Clique em **Create**
5. **Copie e guarde a chave de forma segura** (você não poderá vê-la novamente)

---

## 🔨 Passo 2: Preparar o Projeto para Release

### 2.1 Revisar Versionamento

Verifique o arquivo `TabNewsClientCore.csproj`:

```xml
<PropertyGroup>
    <Version>2.0.0</Version>
    ...
</PropertyGroup>
```

Se precisar mudar a versão, edite antes de compilar.

### 2.2 Compilar em Release

```bash
cd c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore
dotnet clean
dotnet build --configuration Release
```

---

## 📦 Passo 3: Gerar Pacote NuGet

### 3.1 Criar o arquivo .nupkg

```bash
dotnet pack --configuration Release
```

**Saída esperada:**
```
Successfully created package 'C:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\bin\Release\TabNewsClientCore.2.0.0.nupkg'.
```

### 3.2 Verificar o pacote gerado

O arquivo deve estar em:
```
bin/Release/TabNewsClientCore.2.0.0.nupkg
```

---

## ✅ Passo 4: Validar o Pacote (Opcional)

### 4.1 Explorar o conteúdo do .nupkg

Use uma ferramenta como:
- [NuGet Package Explorer](https://github.com/NuGetPackageExplorer/NuGetPackageExplorer)
- Ou descompacte como ZIP para inspecionar

Procure por:
- ✅ DLL compilada em `lib/net8.0/`
- ✅ Arquivo XML de documentação (`TabNewsClientCore.xml`)
- ✅ `nuspec` correto com metadados

---

## 🚀 Passo 5: Publicar no NuGet.org

### 5.1 Via NuGet CLI (Recomendado)

```bash
cd bin/Release

# Substitua <API_KEY> pela chave copiada
dotnet nuget push TabNewsClientCore.2.0.0.nupkg --api-key <API_KEY> --source https://api.nuget.org/v3/index.json
```

### 5.2 Exemplo Completo

```bash
cd c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\bin\Release
dotnet nuget push TabNewsClientCore.2.0.0.nupkg --api-key oy2abc123def456ghi789jkl123mno456pqr --source https://api.nuget.org/v3/index.json
```

### 5.3 Resposta Esperada

```
Pushing TabNewsClientCore.2.0.0.nupkg to 'https://www.nuget.org/api/v2/package'...
Your package was pushed.
```

---

## 🔍 Passo 6: Verificar Publicação

### 6.1 Verificar na Web

1. Acesse: https://www.nuget.org/packages/TabNewsClientCore/
2. Procure pela versão `2.0.0`
3. Verifique os metadados:
   - ✅ Descrição
   - ✅ Autores
   - ✅ Tags
   - ✅ Repositório

### 6.2 Verificar via CLI

```bash
nuget list TabNewsClientCore -AllVersions -Source https://api.nuget.org/v3/index.json
```

---

## 📥 Passo 7: Testar Instalação

### 7.1 Criar um Projeto Teste

```bash
dotnet new console -n TestTabNewsClientCore
cd TestTabNewsClientCore
```

### 7.2 Adicionar Referência ao Pacote

```bash
dotnet add package TabNewsClientCore
```

### 7.3 Testar a Importação

Edite `Program.cs`:

```csharp
using TabNewsClientCore;
using TabNewsClientCore.Entities;

Console.WriteLine("TabNewsClientCore importado com sucesso!");
Console.WriteLine($"Base URL: {TabNewsApi.BaseUrlApi}");
```

### 7.4 Executar

```bash
dotnet run
```

**Saída esperada:**
```
TabNewsClientCore importado com sucesso!
Base URL: https://www.tabnews.com.br/api/v1/
```

---

## 🔄 Passo 8: Atualizar Versão (Futuras Releases)

Para lançar uma nova versão:

### 8.1 Atualizar arquivo .csproj

```xml
<Version>2.0.1</Version>  <!-- Aumentar versão -->
```

### 8.2 Compilar e Publicar

```bash
dotnet pack --configuration Release
cd bin/Release
dotnet nuget push TabNewsClientCore.2.0.1.nupkg --api-key <API_KEY>
```

---

## ⚠️ Troubleshooting

### Erro: "Invalid API key"
- **Causa**: API key incorreta ou expirada
- **Solução**: Gere uma nova chave no NuGet.org

### Erro: "The feed does not support this API"
- **Causa**: Source incorreta
- **Solução**: Use: `https://api.nuget.org/v3/index.json`

### Erro: "Package with version already exists"
- **Causa**: Tentando publicar versão já existente
- **Solução**: Aumente o número da versão em `.csproj`

### Erro: "The package cannot be expanded"
- **Causa**: .nupkg corrompido
- **Solução**: Delete `bin/Release` e recompile

### Pacote publicado, mas não aparece
- **Causa**: Indexação pode levar alguns minutos
- **Solução**: Aguarde 5-10 minutos e recarregue

---

## 📚 Recursos Úteis

- [Documentação NuGet Oficial](https://docs.microsoft.com/en-us/nuget/)
- [Publishing Packages](https://docs.microsoft.com/en-us/nuget/nuget-org/publish-a-package)
- [Semantic Versioning](https://semver.org/)
- [.nupkg Format](https://docs.microsoft.com/en-us/nuget/reference/nuspec)

---

## ✅ Checklist Final

Antes de publicar, confirme:

- [ ] Versão foi atualizada em `.csproj`
- [ ] Compilação Release bem-sucedida
- [ ] Pacote `.nupkg` gerado
- [ ] API Key do NuGet.org obtida
- [ ] Documentação XML foi gerada
- [ ] README.md está correto
- [ ] Descrição do pacote está adequada
- [ ] Tags e categorias estão corretos
- [ ] Projeto foi adicionado ao GitHub (recomendado)

---

## 🎉 Parabéns!

Após seguir estes passos, seu pacote estará disponível para instalação via:

```bash
dotnet add package TabNewsClientCore
```

ou

```bash
Install-Package TabNewsClientCore
```

---

**Última atualização**: 24 de Dezembro de 2024
