# 🚀 QUICK START - TabNewsClientCore

## Arquivos Principais

### 📍 Localização do Projeto
```
c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\
```

### 📦 Pacote NuGet Gerado
```
c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\bin\Release\TabNewsClientCore.2.0.0.nupkg
```

---

## 📚 Documentação Recomendada (Ordem de Leitura)

1. **[PROJETO_CONCLUIDO.md](PROJETO_CONCLUIDO.md)** ⭐ COMECE AQUI
   - Visão geral completa do projeto
   - Status de cada componente
   - Próximos passos

2. **[TabNewsClientCore/README.md](TabNewsClientCore/README.md)** 
   - Guia de uso do SDK
   - Exemplos de código
   - Referência de classes

3. **[GUIA_PUBLICACAO_NUGET.md](GUIA_PUBLICACAO_NUGET.md)**
   - Passo a passo para publicar no NuGet
   - Troubleshooting
   - Testes de instalação

4. **[PLANO_MIGRACAO_TABNEWSCLIENTCORE.md](PLANO_MIGRACAO_TABNEWSCLIENTCORE.md)**
   - Detalhes da migração do TabNewsCSharpSDK
   - Lista de mudanças
   - Melhorias futuras

5. **[SUMARIO_PROJETO_TABNEWSCLIENTCORE.md](SUMARIO_PROJETO_TABNEWSCLIENTCORE.md)**
   - Sumário técnico do projeto
   - Estatísticas
   - Checklist de conclusão

---

## ⚡ Comandos Úteis

### Compilar o Projeto
```bash
cd c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore

# Debug
dotnet build

# Release
dotnet build --configuration Release
```

### Gerar Pacote NuGet
```bash
cd c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore
dotnet pack --configuration Release
```

### Publicar no NuGet
```bash
cd c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\bin\Release

# Substitua <API_KEY> pela sua chave
dotnet nuget push TabNewsClientCore.2.0.0.nupkg --api-key <API_KEY> --source https://api.nuget.org/v3/index.json
```

### Testar Instalação Local
```bash
# Criar novo projeto
dotnet new console -n TestApp
cd TestApp

# Adicionar referência ao pacote local
dotnet add package TabNewsClientCore --source c:\Users\danielcaze\source\repos\TabNewsAPI\TabNewsClientCore\bin\Release\
```

---

## 🔑 Informações do Pacote

| Propriedade | Valor |
|------------|-------|
| **ID** | TabNewsClientCore |
| **Versão** | 2.0.0 |
| **Autor** | Programador Raiz |
| **Licença** | MIT |
| **Framework** | .NET 8.0 |
| **Tags** | TabNews, SDK, Client, .NET8 |

---

## 📊 Conteúdo do Pacote

```
Namespaces Públicos:
  • TabNewsClientCore
  • TabNewsClientCore.Entities

Classes Principais:
  • TabNewsApi (5 métodos públicos)
  • TabNewsContent
  • TabNewsContentResponse
  • TabNewsUser
  • TabNewsUserSession
  • TabNewsException

Dependências:
  • RestSharp (>= 113.0.0)
  • Newtonsoft.Json (>= 13.0.4)
```

---

## ✨ Exemplo de Uso Rápido

```csharp
using TabNewsClientCore;

// 1. Autenticar
var session = TabNewsApi.LoginUser("email@example.com", "password");
Console.WriteLine($"Login bem-sucedido!");

// 2. Obter informações do usuário
var user = TabNewsApi.GetUser(session.Id);
Console.WriteLine($"Usuário: {user.Username}");

// 3. Listar posts do usuário
var posts = TabNewsApi.Get10LastedPosts(user.Username);
Console.WriteLine($"Posts: {posts.Count}");
```

---

## 🔗 Links Importantes

### NuGet
- 📦 [NuGet.org](https://www.nuget.org)
- 🔑 [API Keys](https://www.nuget.org/account/apikeys)
- 📚 [Documentação](https://docs.microsoft.com/en-us/nuget/)

### Projeto
- 🌐 [TabNews](https://www.tabnews.com.br)
- 📡 [API TabNews](https://tabnews.com.br/api/v1)
- 🐙 [GitHub](https://github.com/dsscaze/TabNewsAPI)

### Ferramentas
- 📦 [NuGet Package Explorer](https://github.com/NuGetPackageExplorer/NuGetPackageExplorer)
- 🔍 [dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/)

---

## ⚙️ Estrutura do Projeto

```
TabNewsClientCore/
├── TabNewsApi.cs              (Classe principal)
├── README.md                   (Documentação de uso)
├── Entities/
│   ├── TabNewsContent.cs
│   ├── TabNewsContentResponse.cs
│   ├── TabNewsException.cs
│   ├── TabNewsUser.cs
│   └── TabNewsUserSession.cs
└── bin/
    ├── Debug/
    └── Release/
        └── TabNewsClientCore.2.0.0.nupkg ⭐
```

---

## 🎯 Checklist Pré-Publicação

- [ ] Ler [PROJETO_CONCLUIDO.md](PROJETO_CONCLUIDO.md)
- [ ] Ler [GUIA_PUBLICACAO_NUGET.md](GUIA_PUBLICACAO_NUGET.md)
- [ ] Criar conta no NuGet.org (se não tiver)
- [ ] Gerar API Key no NuGet.org
- [ ] Testar compilação local
- [ ] Verificar pacote .nupkg
- [ ] Publicar no NuGet
- [ ] Verificar publicação (aguarde 5-10 min)
- [ ] Testar instalação em novo projeto

---

## 📞 Resolução de Problemas Rápida

| Problema | Solução |
|----------|---------|
| Erro de compilação | Verifique: `dotnet build --configuration Release` |
| .nupkg não gerado | Execute: `dotnet pack --configuration Release` |
| API Key inválida | Gere nova chave em https://www.nuget.org/account/apikeys |
| Pacote não aparece | Aguarde 5-10 minutos para indexação |
| Erro ao instalar | Verifique se versão está certa: `dotnet add package TabNewsClientCore::2.0.0` |

---

## 🎉 Parabéns!

Seu projeto está pronto! Agora é só:

1. **Publicar** no NuGet (siga o GUIA_PUBLICACAO_NUGET.md)
2. **Compartilhar** o link: `https://www.nuget.org/packages/TabNewsClientCore/`
3. **Aproveitar** os 10+ anos de funcionalidade do SDK original, agora em .NET moderno! 🚀

---

**Última Atualização**: 24 de Dezembro de 2024  
**Status**: ✅ Pronto para Publicação
