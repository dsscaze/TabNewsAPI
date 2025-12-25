using Newtonsoft.Json;

namespace TabNewsClientCore.Entities;

// Gerado em https://json2csharp.com/
public class TabNewsUser
{
    [JsonProperty("id")]
    public string? Id { get; set; }
    
    [JsonProperty("username")]
    public string? Username { get; set; }
    
    [JsonProperty("email")]
    public string? Email { get; set; }
    
    [JsonProperty("description")]
    public string? Description { get; set; }
    
    [JsonProperty("notifications")]
    public bool Notifications { get; set; }
    
    [JsonProperty("features")]
    public List<string>? Features { get; set; }
    
    [JsonProperty("tabcoins")]
    public int TabCoins { get; set; }
    
    [JsonProperty("tabcash")]
    public int TabCash { get; set; }
    
    [JsonProperty("created_at")]
    public DateTime CreatedAt { get; set; }
    
    [JsonProperty("updated_at")]
    public DateTime UpdatedAt { get; set; }
}
