namespace TabNewsClientCore.Entities;

// Gerado em https://json2csharp.com/
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
