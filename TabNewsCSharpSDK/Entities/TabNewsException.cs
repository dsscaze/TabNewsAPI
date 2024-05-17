using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace TabNewsCSharpSDK.Entities
{
    public class TabNewsException : Exception
    {
        public TabNewsException()
        {
        }

        public TabNewsException(string message) : base(message)
        {
        }

        public TabNewsException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected TabNewsException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
