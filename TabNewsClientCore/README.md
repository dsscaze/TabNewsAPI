# TabNewsClientCore - SDK C# para TabNews (.NET 8.0)

[![NuGet](https://img.shields.io/nuget/v/TabNewsClientCore.svg)](https://www.nuget.org/packages/TabNewsClientCore/)

SDK não-oficial em C# para interagir com a API do [TabNews](https://www.tabnews.com.br) - Uma plataforma de notícias e conteúdo baseada em comunidade.

## 📦 Instalação

### Via NuGet Package Manager
```bash
Install-Package TabNewsClientCore
```

### Via .NET CLI
```bash
dotnet add package TabNewsClientCore
```

## 🚀 Uso Rápido

### Autenticação (Login)
```csharp
using TabNewsClientCore;

// Fazer login
var session = TabNewsApi.LoginUser("seu_email@example.com", "sua_senha");
Console.WriteLine($"Token: {session.Token}");
```

### Obter Informações do Usuário
```csharp
// Obter dados do usuário autenticado
var user = TabNewsApi.GetUser(session.Id);
Console.WriteLine($"Usuário: {user.Username}");
Console.WriteLine($"TabCoins: {user.TabCoins}");
```

### Obter Conteúdo Específico
```csharp
// Buscar um artigo específico
var content = TabNewsApi.GetContent("nome_usuario", "slug-do-artigo");
Console.WriteLine($"Título: {content.Title}");
Console.WriteLine($"Corpo: {content.Body}");
```

### Listar Conteúdos com Paginação
```csharp
// Obter conteúdos com paginação
var response = TabNewsApi.GetContents("nome_usuario", perPage: 10, page: 1);
Console.WriteLine($"Total de posts: {response.TotalPosts}");
foreach (var post in response.Contents)
{
    Console.WriteLine($"- {post.Title}");
}
```

### Obter Últimos 10 Posts de um Usuário
```csharp
// Busca automaticamente todos os posts até encontrar 10
var posts = TabNewsApi.Get10LastedPosts("nome_usuario");
Console.WriteLine($"Posts obtidos: {posts.Count}");
```

## 📚 Referência de Classes

### TabNewsApi (Classe Principal)
Classe estática que contém todos os métodos para interagir com a API.

#### Métodos
- `LoginUser(email, password)` - Autentica um usuário
- `GetUser(sessionId)` - Obtém informações do usuário autenticado
- `GetContent(ownerUsername, slug)` - Obtém um conteúdo específico
- `GetContents(ownerUsername, perPage, page, strategy)` - Lista conteúdos com paginação
- `Get10LastedPosts(ownerUsername, perPage, page)` - Obtém os últimos 10 posts

### Entities

#### TabNewsUserSession
Representa uma sessão de usuário após login.
```csharp
public class TabNewsUserSession
{
    public string? Id { get; set; }
    public string? Token { get; set; }
    public DateTime ExpiresAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
```

#### TabNewsUser
Representa as informações de um usuário.
```csharp
public class TabNewsUser
{
    public string? Id { get; set; }
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? Description { get; set; }
    public bool Notifications { get; set; }
    public List<string>? Features { get; set; }
    public int TabCoins { get; set; }
    public int TabCash { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
```

#### TabNewsContent
Representa um artigo ou comentário.
```csharp
public class TabNewsContent
{
    public string? Id { get; set; }
    public string? OwnerId { get; set; }
    public string? ParentId { get; set; }
    public string? Slug { get; set; }
    public string? Title { get; set; }
    public string? Body { get; set; }
    public string? Status { get; set; }
    public string? SourceUrl { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
    public DateTime PublishedAt { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? OwnerUsername { get; set; }
    public int TabCoins { get; set; }
    public int TabCoinsCredit { get; set; }
    public int TabCoinsDebit { get; set; }
    public int ChildrenDeepCount { get; set; }
}
```

#### TabNewsContentResponse
Resposta paginada para requisições de conteúdo.
```csharp
public class TabNewsContentResponse
{
    public int TotalPosts { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
    public List<TabNewsContent> Contents { get; set; }
}
```

#### TabNewsException
Exceção específica lançada por operações da API.
```csharp
public class TabNewsException : Exception
{
    // Construtores padrão
}
```

## 🔄 Migração do TabNewsCSharpSDK

Este projeto é a versão .NET 8.0 moderna do `TabNewsCSharpSDK` (Framework 4.7.2).

### Principais Mudanças
- ✅ .NET 8.0 (com suporte a versões anteriores via multi-targeting)
- ✅ Nullable reference types habilitados
- ✅ Propriedades em PascalCase (conforme conventions C#)
- ✅ Use of latest RestSharp (v113.0.0)
- ✅ XML documentation comments
- ✅ Melhor tratamento de null values

### Compatibilidade de API
A API pública é praticamente idêntica ao SDK antigo, com as seguintes mudanças:

| Antigo | Novo |
|--------|------|
| `id` (propriedades) | `Id` |
| `owner_id` | `OwnerId` |
| `parent_id` | `ParentId` |
| etc. | PascalCase para todas as propriedades |

## 🛠️ Dependências
- `RestSharp` (>= 113.0.0)
- `Newtonsoft.Json` (>= 13.0.4)
- `.NET 8.0` ou superior

## 📝 Exemplo Completo

```csharp
using TabNewsClientCore;
using TabNewsClientCore.Entities;

// 1. Autenticação
var session = TabNewsApi.LoginUser("user@example.com", "password");
Console.WriteLine($"Login bem-sucedido. Token: {session.Token}");

// 2. Obter informações do usuário
var user = TabNewsApi.GetUser(session.Id);
Console.WriteLine($"Usuário: {user.Username}");
Console.WriteLine($"TabCoins: {user.TabCoins}");

// 3. Listar artigos do usuário
var posts = TabNewsApi.Get10LastedPosts(user.Username);
Console.WriteLine($"Últimos {posts.Count} posts:");
foreach (var post in posts)
{
    Console.WriteLine($"- {post.Title} ({post.TabCoins} tabcoins)");
}

// 4. Obter um artigo específico
var article = TabNewsApi.GetContent(user.Username, posts[0].Slug);
Console.WriteLine($"Artigo: {article.Body}");
```

## ⚠️ Tratamento de Erros

```csharp
try
{
    var session = TabNewsApi.LoginUser(email, password);
}
catch (TabNewsException ex)
{
    Console.WriteLine($"Erro ao fazer login: {ex.Message}");
}
```

## 📄 Licença
MIT

## 👤 Autor
Programador Raiz

## 🔗 Links
- [Site do TabNews](https://www.tabnews.com.br)
- [API Documentation](https://tabnews.com.br/api/v1)
- [Repositório GitHub](https://github.com/dsscaze/TabNewsAPI)

## 🤝 Contribuições
Contribuições são bem-vindas! Sinta-se livre para abrir issues ou pull requests.

---

**Nota**: Este é um SDK não-oficial. Para questões sobre a API, visite [tabnews.com.br](https://www.tabnews.com.br)
