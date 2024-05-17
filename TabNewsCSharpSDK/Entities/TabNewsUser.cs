using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TabNewsCSharpSDK.Entities
{
    // gerado em https://json2csharp.com/
    public class TabNewsUser
    {
        public string id { get; set; }
        public string username { get; set; }
        public string email { get; set; }
        public string description { get; set; }
        public bool notifications { get; set; }
        public List<string> features { get; set; }
        public int tabcoins { get; set; }
        public int tabcash { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    }
}
