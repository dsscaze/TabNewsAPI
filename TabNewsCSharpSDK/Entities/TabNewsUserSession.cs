using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TabNewsCSharpSDK.Entities
{
    // gerado em https://json2csharp.com/
    public class TabNewsUserSession
    {
        public string id { get; set; }
        public string token { get; set; }
        public DateTime expires_at { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    }
}
