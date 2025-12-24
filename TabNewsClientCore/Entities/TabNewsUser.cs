namespace TabNewsClientCore.Entities;

// Gerado em https://json2csharp.com/
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
