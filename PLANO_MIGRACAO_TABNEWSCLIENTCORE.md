# Plano de Migração - TabNewsClientCore (.NET 8.0)

## Objetivo
Migrar o projeto `TabNewsCSharpSDK` (Framework 4.7.2) para um novo projeto `TabNewsClientCore` (.NET 8.0) para publicação no NuGet com suporte a .NET moderno.

---

## Estrutura do Projeto Atual (TabNewsCSharpSDK)

```
TabNewsCSharpSDK/
├── TabNewsApi.cs (classe principal com métodos estáticos)
├── Entities/
│   ├── TabNewsContent.cs
│   ├── TabNewsContentResponse.cs
│   ├── TabNewsUser.cs
│   ├── TabNewsUserSession.cs
│   └── TabNewsException.cs
├── Properties/
└── packages.config
```

---

## Tarefas de Migração

### Fase 1: Estrutura Base ✅
- [x] Criar novo projeto `TabNewsClientCore` com .NET 8.0
- [x] Adicionar dependências: `RestSharp` e `Newtonsoft.Json`
- [x] Criar pasta `Entities`

### Fase 2: Migração de Entidades ✅
- [x] Migrar `TabNewsException.cs`
  - [x] Remover `using` desnecessários
  - [x] Adicionar pragma para avisos de serialização obsoleta

- [x] Migrar `TabNewsUserSession.cs`
  - [x] Remover `using` desnecessários
  - [x] Atualizar nomes de propriedades para PascalCase
  - [x] Adicionar nullable reference types

- [x] Migrar `TabNewsUser.cs`
  - [x] Remover `using` desnecessários
  - [x] Atualizar nomes de propriedades para PascalCase
  - [x] Implementar nullable reference types

- [x] Migrar `TabNewsContent.cs`
  - [x] Remover `using` desnecessários
  - [x] Atualizar nomes de propriedades para PascalCase
  - [x] Implementar nullable reference types

- [x] Migrar `TabNewsContentResponse.cs`
  - [x] Remover `using` desnecessários

### Fase 3: Migração da Classe Principal ✅
- [x] Migrar `TabNewsApi.cs`
  - [x] Adaptar imports para `TabNewsClientCore.Entities`
  - [x] Remover `MaxTimeout` (não suportado no RestSharp 113.0.0)
  - [x] Adaptar acesso aos headers da resposta
  - [x] Adicionar tratamento de null para deserialização JSON
  - [x] Remover `using` desnecessários
  - [x] Adicionar XML documentation comments

### Fase 4: Configuração de Publicação NuGet ✅
- [x] Atualizar arquivo `TabNewsClientCore.csproj`
  - [x] Adicionar metadados de pacote
  - [x] Configurar versionamento
  - [x] Habilitar geração de documentação XML

### Fase 5: Testes e Validação ✅
- [x] Compilar o projeto sem erros
- [x] Revisar compatibilidade com RestSharp 113.0.0
- [x] Validar tratamento de erros
- [x] Validar desserialização JSON com `Newtonsoft.Json`

### Fase 6: Documentação ✅
- [x] Criar `README.md` do novo projeto
- [x] Documentar exemplos de uso
- [x] Documentar mudanças de propriedades (snake_case → PascalCase)

### Fase 7: Integração na Solução ✅
- [x] Adicionar projeto à solução `TabNewsAPI.sln`

---

## Notas Importantes

### Compatibilidade
- **RestSharp**: Versão 113.0.0 (mais nova) vs 110.2.0 (versão atual)
  - Verificar mudanças de API
  - Validar se métodos como `.get_Name()` e `.get_Value()` ainda existem

### Melhorias Recomendadas (Futuras)
- [ ] Implementar versões assíncronas dos métodos (async/await)
- [ ] Adicionar suporte para `HttpClient` moderno (RemoveRestSharp eventual)
- [ ] Adicionar testes unitários
- [ ] Implementar injeção de dependência
- [ ] Adicionar logging
- [ ] Considerar usar `System.Text.Json` ao invés de `Newtonsoft.Json`

### Versionamento
- Versão atual: `1.0.3`
- Sugestão para novo pacote: `2.0.0` (breaking change em comparação com a versão antiga)

---

## Próximas Etapas (Após Implementação Inicial)

### Fase 8: Publicação no NuGet
- [ ] Compilar versão Release: `dotnet build --configuration Release`
- [ ] Gerar pacote: `dotnet pack --configuration Release`
- [ ] Validar arquivo `.nupkg` em `bin/Release/`
- [ ] Obter API Key do NuGet.org
- [ ] Publicar: `dotnet nuget push bin/Release/TabNewsClientCore.2.0.0.nupkg --api-key <API_KEY>`
- [ ] Verificar publicação em https://www.nuget.org/packages/TabNewsClientCore/
- [ ] Testar instalação via NuGet

### Melhorias Futuras Recomendadas
- [ ] Implementar versões assíncronas dos métodos (async/await)
  - `LoginUserAsync()`
  - `GetUserAsync()`
  - `GetContentAsync()`
  - `GetContentsAsync()`
  - `Get10LastedPostsAsync()`

- [ ] Migrar de `Newtonsoft.Json` para `System.Text.Json` (nativo .NET 8.0)
- [ ] Adicionar suporte para `HttpClient` moderno (em vez de RestSharp)
- [ ] Criar projeto de testes unitários
- [ ] Implementar injeção de dependência (ITabNewsApi)
- [ ] Adicionar logging com `ILogger`
- [ ] Criar exemplos de uso
- [ ] Adicionar validação de entrada

---
