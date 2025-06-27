using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading;

[DataContract]
class Message
{
    [DataMember] public string type;
    [DataMember] public string content;
    [DataMember] public string timestamp;
}

class WebSocketServer
{
    static void Main()
    {
        TcpListener listener = new TcpListener(IPAddress.Loopback, 8080);
        listener.Start();
        Console.WriteLine("Listening on ws://localhost:8080");

        while (true)
        {
            TcpClient client = listener.AcceptTcpClient();
            Thread thread = new Thread(HandleClient);
            thread.Start(client);
        }
    }

    static void HandleClient(object obj)
    {
        TcpClient client = (TcpClient)obj;
        NetworkStream stream = client.GetStream();

        while (!stream.DataAvailable) Thread.Sleep(10);

        byte[] buffer = new byte[client.Available];
        stream.Read(buffer, 0, buffer.Length);
        string request = Encoding.UTF8.GetString(buffer);

        if (request.StartsWith("GET"))
        {
            string key = GetKey(request);
            string accept = ComputeAcceptKey(key);

            string response = "HTTP/1.1 101 Switching Protocols\r\n" +
                              "Connection: Upgrade\r\n" +
                              "Upgrade: websocket\r\n" +
                              "Sec-WebSocket-Accept: " + accept + "\r\n\r\n";

            byte[] responseBytes = Encoding.UTF8.GetBytes(response);
            stream.Write(responseBytes, 0, responseBytes.Length);
            Console.WriteLine("Handshake complete.");

            while (true)
            {
                if (!stream.DataAvailable) { Thread.Sleep(10); continue; }

                byte[] header = new byte[2];
                stream.Read(header, 0, 2);
                int len = header[1] & 0x7F;

                byte[] mask = new byte[4];
                stream.Read(mask, 0, 4);

                byte[] payload = new byte[len];
                stream.Read(payload, 0, len);
                for (int i = 0; i < len; i++) payload[i] ^= mask[i % 4];

                string json = Encoding.UTF8.GetString(payload);
                Console.WriteLine("📩 Received JSON: " + json);

                // Deserialize
                var serializer = new DataContractJsonSerializer(typeof(Message));
                using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
                {
                    Message msg = (Message)serializer.ReadObject(ms);
                    msg.content = "Echo: " + msg.content;
                    msg.timestamp = DateTime.UtcNow.ToString("o");

                    using (var replyStream = new MemoryStream())
                    {
                        serializer.WriteObject(replyStream, msg);
                        byte[] reply = replyStream.ToArray();

                        byte[] frame = new byte[2 + reply.Length];
                        frame[0] = 0x81;
                        frame[1] = (byte)reply.Length;
                        Array.Copy(reply, 0, frame, 2, reply.Length);
                        stream.Write(frame, 0, frame.Length);
                    }
                }
            }
        }

        stream.Close();
        client.Close();
    }

    static string GetKey(string req)
    {
        foreach (var line in req.Split(new[] { "\r\n" }, StringSplitOptions.None))
            if (line.StartsWith("Sec-WebSocket-Key:"))
                return line.Substring(18).Trim();
        return null;
    }

    static string ComputeAcceptKey(string key)
    {
        string magic = key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
        byte[] hash = System.Security.Cryptography.SHA1.Create().ComputeHash(Encoding.UTF8.GetBytes(magic));
        return Convert.ToBase64String(hash);
    }
}
