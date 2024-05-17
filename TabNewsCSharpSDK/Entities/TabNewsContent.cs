using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TabNewsCSharpSDK.Entities
{
    // gerado em https://json2csharp.com/
    public class TabNewsContent
    {
        public string id { get; set; }
        public string owner_id { get; set; }
        public string parent_id { get; set; }
        public string slug { get; set; }
        public string title { get; set; }
        public string body { get; set; }
        public string status { get; set; }
        public string source_url { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public DateTime published_at { get; set; }
        public DateTime? deleted_at { get; set; }
        public string owner_username { get; set; }
        public int tabcoins { get; set; }
        public int tabcoins_credit { get; set; }
        public int tabcoins_debit { get; set; }
        public int children_deep_count { get; set; }
    }
}
