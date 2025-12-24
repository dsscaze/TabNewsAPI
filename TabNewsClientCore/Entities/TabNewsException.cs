using System.Runtime.Serialization;

namespace TabNewsClientCore.Entities;

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

#pragma warning disable SYSLIB0051
    protected TabNewsException(SerializationInfo info, StreamingContext context) : base(info, context)
    {
    }
#pragma warning restore SYSLIB0051
}
