using Newtonsoft.Json;
using RestSharp;
using TabNewsClientCore.Entities;

namespace TabNewsClientCore;

public static class TabNewsApi
{
    public const string BaseUrlApi = "https://www.tabnews.com.br/api/v1/";

    /// <summary>
    /// Realiza login do usuário na API do TabNews
    /// </summary>
    /// <param name="email">Email do usuário</param>
    /// <param name="password">Senha do usuário</param>
    /// <returns>Sessão do usuário contendo token de autenticação</returns>
    /// <exception cref="TabNewsException">Lançado quando o login falha</exception>
    public static TabNewsUserSession LoginUser(string email, string password)
    {
        var options = new RestClientOptions(BaseUrlApi)
        {
            FollowRedirects = false
        };

        var client = new RestClient(options);
        var request = new RestRequest("sessions", Method.Post);

        request.AddParameter("email", email);
        request.AddParameter("password", password);

        RestResponse response = client.Execute(request);
        var userSession = JsonConvert.DeserializeObject<TabNewsUserSession>(response.Content ?? "");
        
        if (userSession?.Token == null)
        {
            throw new TabNewsException($"Falha ao fazer login: {response.Content}");
        }

        return userSession;
    }

    /// <summary>
    /// Obtém informações do usuário autenticado
    /// </summary>
    /// <param name="ownerUsername">Nome de usuário do proprietário</param>
    /// <returns>Informações do usuário</returns>
    /// <exception cref="TabNewsException">Lançado quando a requisição falha</exception>
    public static TabNewsUser GetUser(string ownerUsername)
    {
        var options = new RestClientOptions(BaseUrlApi);
        var client = new RestClient(options);
        var request = new RestRequest($"users/{ownerUsername}", Method.Get);

        RestResponse response = client.Execute(request);

        var tabNewUser = JsonConvert.DeserializeObject<TabNewsUser>(response.Content ?? "");

        if (string.IsNullOrEmpty(tabNewUser?.Id))
        {
            throw new TabNewsException($"Falha ao obter usuário: {response.Content}");
        }

        return tabNewUser;
    }

    /// <summary>
    /// Obtém conteúdo específico do usuário
    /// </summary>
    /// <param name="ownerUsername">Nome de usuário do proprietário</param>
    /// <param name="slug">Slug do conteúdo</param>
    /// <returns>Conteúdo solicitado</returns>
    /// <exception cref="TabNewsException">Lançado quando o conteúdo não é encontrado</exception>
    public static TabNewsContent GetContent(string ownerUsername, string slug)
    {
        var options = new RestClientOptions(BaseUrlApi);

        var client = new RestClient(options);
        var request = new RestRequest($"contents/{ownerUsername}/{slug}", Method.Get);
        RestResponse response = client.Execute(request);

        var tabNewContent = JsonConvert.DeserializeObject<TabNewsContent>(response.Content ?? "");
        
        if (string.IsNullOrEmpty(tabNewContent?.Id))
        {
            throw new TabNewsException($"Falha ao obter conteúdo: {response.Content}");
        }

        return tabNewContent;
    }

    /// <summary>
    /// Obtém conteúdos do usuário com paginação
    /// </summary>
    /// <param name="ownerUsername">Nome de usuário do proprietário</param>
    /// <param name="perPage">Quantidade de itens por página</param>
    /// <param name="page">Número da página</param>
    /// <param name="strategy">Estratégia de busca (padrão: "new")</param>
    /// <returns>Resposta contendo conteúdos e informações de paginação</returns>
    /// <exception cref="TabNewsException">Lançado quando a requisição falha</exception>
    public static TabNewsContentResponse GetContents(string ownerUsername, int perPage, int page, string strategy = "new")
    {
        var tabNewsResponse = new TabNewsContentResponse
        {
            Page = page,
            PageSize = perPage
        };

        RestResponse response = GetContentBase(ownerUsername, perPage, page, strategy);
        
        if (response.IsSuccessful)
        {
            var headers = response.Headers ?? [];
            var headerValue = headers
                .FirstOrDefault(x => x.Name == "x-pagination-total-rows");
            
            if (headerValue?.Value is not null)
            {
                tabNewsResponse.TotalPosts = Convert.ToInt32(headerValue.Value);
            }

            var tabNewsContents = JsonConvert.DeserializeObject<List<TabNewsContent>>(response.Content ?? "");
            tabNewsResponse.Contents = tabNewsContents ?? new List<TabNewsContent>();
        }
        else
        {
            throw new TabNewsException($"Falha ao obter conteúdos: {response.Content}");
        }

        return tabNewsResponse;
    }

    /// <summary>
    /// Obtém os últimos 10 posts (não comentários) de um usuário
    /// </summary>
    /// <param name="ownerUsername">Nome de usuário do proprietário</param>
    /// <param name="perPage">Quantidade de itens por página (padrão: 10)</param>
    /// <param name="page">Página inicial (padrão: 1)</param>
    /// <returns>Lista contendo até 10 posts</returns>
    /// <exception cref="TabNewsException">Lançado quando a requisição falha</exception>
    public static List<TabNewsContent> Get10LastedPosts(string ownerUsername, int perPage = 10, int page = 1)
    {
        bool searchNewContent = true;
        var tabNewsContents = new List<TabNewsContent>();

        while (searchNewContent && tabNewsContents.Count < 10)
        {
            RestResponse response = GetContentBase(ownerUsername, perPage, page);

            if (response.IsSuccessful)
            {
                var contents = JsonConvert.DeserializeObject<List<TabNewsContent>>(response.Content ?? "");
                if (contents != null)
                {
                    // Filtrar apenas posts (ParentId == null) e excluir conteúdo deletado
                    var posts = contents
                        .Where(p => string.IsNullOrEmpty(p.ParentId) && p.DeletedAt == null)
                        .ToList();
                    
                    tabNewsContents.AddRange(posts);
                }

                var headers = response.Headers ?? [];
                var headerValue = headers
                    .FirstOrDefault(x => x.Name == "x-pagination-total-rows");

                if (headerValue?.Value is not null)
                {
                    int totalPosts = Convert.ToInt32(headerValue.Value);
                    decimal quo = totalPosts / (decimal)perPage;
                    int totalPages = (int)Math.Ceiling(quo);

                    if (tabNewsContents.Count >= 10)
                    {
                        searchNewContent = false;
                    }
                    else if (totalPages > page)
                    {
                        page++;
                    }
                    else
                    {
                        searchNewContent = false;
                    }
                }
                else
                {
                    searchNewContent = false;
                }
            }
            else
            {
                throw new TabNewsException($"Falha ao obter posts: {response.Content}");
            }
        }

        // Retornar apenas os primeiros 10 posts
        return tabNewsContents.Take(10).ToList();
    }

    /// <summary>
    /// Requisição base para obter conteúdos com parâmetros de query
    /// </summary>
    private static RestResponse GetContentBase(string ownerUsername, int perPage, int page, string strategy = "new")
    {
        var options = new RestClientOptions(BaseUrlApi);

        var client = new RestClient(options);
        var request = new RestRequest($"contents/{ownerUsername}?page={page}&per_page={perPage}&strategy={strategy}", Method.Get);
        
        return client.Execute(request);
    }
}
