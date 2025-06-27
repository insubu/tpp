using System;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;

[DataContract]
class Payload
{
    [DataMember] public string type;
    [DataMember] public string content;
    [DataMember] public string timestamp;
}

class Program
{
    static void Main()
    {
        Payload data = new Payload
        {
            type = "userMessage",
            content = "hello",
            timestamp = DateTime.UtcNow.ToString("o")
        };

        var serializer = new DataContractJsonSerializer(typeof(Payload));
        using (var ms = new MemoryStream())
        {
            serializer.WriteObject(ms, data);
            string json = Encoding.UTF8.GetString(ms.ToArray());
            Console.WriteLine("📤 JSON Output:\n" + json);
        }
    }
}
