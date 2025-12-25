using Newtonsoft.Json;

namespace TabNewsClientCore.Entities;

// Gerado em https://json2csharp.com/
public class TabNewsUserSession
{
    [JsonProperty("id")]
    public string? Id { get; set; }
    
    [JsonProperty("token")]
    public string? Token { get; set; }
    
    [JsonProperty("expires_at")]
    public DateTime ExpiresAt { get; set; }
    
    [JsonProperty("created_at")]
    public DateTime CreatedAt { get; set; }
    
    [JsonProperty("updated_at")]
    public DateTime UpdatedAt { get; set; }
}
