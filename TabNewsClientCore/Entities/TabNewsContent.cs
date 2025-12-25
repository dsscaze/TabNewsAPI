using Newtonsoft.Json;

namespace TabNewsClientCore.Entities;

// Gerado em https://json2csharp.com/
public class TabNewsContent
{
    [JsonProperty("id")]
    public string? Id { get; set; }
    
    [JsonProperty("owner_id")]
    public string? OwnerId { get; set; }
    
    [JsonProperty("parent_id")]
    public string? ParentId { get; set; }
    
    [JsonProperty("slug")]
    public string? Slug { get; set; }
    
    [JsonProperty("title")]
    public string? Title { get; set; }
    
    [JsonProperty("body")]
    public string? Body { get; set; }
    
    [JsonProperty("status")]
    public string? Status { get; set; }
    
    [JsonProperty("source_url")]
    public string? SourceUrl { get; set; }
    
    [JsonProperty("created_at")]
    public DateTime CreatedAt { get; set; }
    
    [JsonProperty("updated_at")]
    public DateTime UpdatedAt { get; set; }
    
    [JsonProperty("published_at")]
    public DateTime PublishedAt { get; set; }
    
    [JsonProperty("deleted_at")]
    public DateTime? DeletedAt { get; set; }
    
    [JsonProperty("owner_username")]
    public string? OwnerUsername { get; set; }
    
    [JsonProperty("tabcoins")]
    public int TabCoins { get; set; }
    
    [JsonProperty("tabcoins_credit")]
    public int TabCoinsCredit { get; set; }
    
    [JsonProperty("tabcoins_debit")]
    public int TabCoinsDebit { get; set; }
    
    [JsonProperty("children_deep_count")]
    public int ChildrenDeepCount { get; set; }
}

public class TabNewsContentResponse
{
    public TabNewsContentResponse()
    {
        Contents = new List<TabNewsContent>();
    }

    public int TotalPosts { get; set; }
    public int Page { get; set; }
    public int PageSize { get; set; }
    public List<TabNewsContent> Contents { get; set; }
}
