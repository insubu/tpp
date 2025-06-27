using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Security.Cryptography;

class WebSocketServer
{
    static void Main()
    {
        var listener = new TcpListener(IPAddress.Loopback, 8080);
        listener.Start();
        Console.WriteLine("Listening on ws://localhost:8080");

        while (true)
        {
            using var client = listener.AcceptTcpClient();
            using var stream = client.GetStream();

            // Wait for handshake
            while (!stream.DataAvailable) ;

            byte[] buffer = new byte[client.Available];
            stream.Read(buffer, 0, buffer.Length);
            string request = Encoding.UTF8.GetString(buffer);

            if (request.StartsWith("GET"))
            {
                string key = GetWebSocketKey(request);
                string acceptKey = ComputeWebSocketAcceptKey(key);

                string response = "HTTP/1.1 101 Switching Protocols\r\n" +
                                  "Connection: Upgrade\r\n" +
                                  "Upgrade: websocket\r\n" +
                                  $"Sec-WebSocket-Accept: {acceptKey}\r\n\r\n";

                byte[] responseBytes = Encoding.UTF8.GetBytes(response);
                stream.Write(responseBytes, 0, responseBytes.Length);
                Console.WriteLine("Handshake complete.");

                // Echo loop
                while (true)
                {
                    if (!stream.DataAvailable) continue;

                    byte[] recv = new byte[2];
                    stream.Read(recv, 0, 2);
                    int payloadLen = recv[1] & 0x7F;

                    byte[] mask = new byte[4];
                    stream.Read(mask, 0, 4);

                    byte[] payload = new byte[payloadLen];
                    stream.Read(payload, 0, payloadLen);

                    for (int i = 0; i < payloadLen; i++)
                        payload[i] ^= mask[i % 4];

                    string msg = Encoding.UTF8.GetString(payload);
                    Console.WriteLine("Received: " + msg);

                    // Echo back
                    byte[] send = Encoding.UTF8.GetBytes(msg);
                    byte[] frame = new byte[2 + send.Length];
                    frame[0] = 0x81; // FIN + text
                    frame[1] = (byte)send.Length;
                    Array.Copy(send, 0, frame, 2, send.Length);
                    stream.Write(frame, 0, frame.Length);
                }
            }
        }
    }

    static string GetWebSocketKey(string request)
    {
        foreach (var line in request.Split(new[] { "\r\n" }, StringSplitOptions.None))
            if (line.StartsWith("Sec-WebSocket-Key:"))
                return line.Split(':')[1].Trim();
        return null;
    }

    static string ComputeWebSocketAcceptKey(string key)
    {
        string magic = key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
        byte[] hash = SHA1.Create().ComputeHash(Encoding.UTF8.GetBytes(magic));
        return Convert.ToBase64String(hash);
    }
}

---------------------
const socket = new WebSocket("ws://localhost:8080");

socket.onopen = () => {
  console.log("✅ Connected to server");
};

socket.onmessage = (event) => {
  console.log("📩 Message received:", event.data);

  // Do something with the message
  if (event.data === "ping") {
    socket.send("pong");
  } else {
    alert("Got: " + event.data);
  }
};

socket.onerror = (err) => {
  console.error("❌ WebSocket error:", err);
};

socket.onclose = () => {
  console.log("🔌 Connection closed");
};
--------------------------------
    <!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>WebSocket Chat</title>
  <style>
    body { font-family: sans-serif; margin: 2em; }
    #log { border: 1px solid #ccc; padding: 1em; height: 200px; overflow-y: auto; background: #f9f9f9; }
    #sendBox { margin-top: 1em; }
  </style>
</head>
<body>
  <h2>💬 WebSocket Client</h2>
  <div id="log"></div>
  <div id="sendBox">
    <input type="text" id="message" placeholder="Type a message..." />
    <button onclick="sendMessage()">Send</button>
  </div>

  <script>
    const log = document.getElementById("log");
    const socket = new WebSocket("ws://localhost:8080");

    socket.onopen = () => logMessage("✅ Connected");
    socket.onmessage = (e) => logMessage("📩 " + e.data);
    socket.onerror = (e) => logMessage("❌ Error: " + e.message);
    socket.onclose = () => logMessage("🔌 Disconnected");

    function sendMessage() {
      const input = document.getElementById("message");
      const msg = input.value;
      if (socket.readyState === WebSocket.OPEN) {
        socket.send(msg);
        logMessage("📤 " + msg);
        input.value = "";
      } else {
        logMessage("⚠️ Connection not open.");
      }
    }

    function logMessage(msg) {
      const p = document.createElement("div");
      p.textContent = msg;
      log.appendChild(p);
      log.scrollTop = log.scrollHeight;
    }
  </script>
</body>
</html>
