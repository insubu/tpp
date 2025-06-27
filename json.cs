byte[] BuildServerFrame(string message)
{
    byte[] payload = Encoding.UTF8.GetBytes(message);
    int len = payload.Length;

    List<byte> frame = new List<byte>();
    frame.Add(0x81); // FIN + text frame

    if (len <= 125)
    {
        frame.Add((byte)len);
    }
    else if (len <= ushort.MaxValue)
    {
        frame.Add(126);
        frame.Add((byte)((len >> 8) & 0xFF)); // high byte
        frame.Add((byte)(len & 0xFF));        // low byte
    }
    else
    {
        frame.Add(127);
        for (int i = 7; i >= 0; i--)
            frame.Add((byte)((len >> (8 * i)) & 0xFF));
    }

    frame.AddRange(payload);
    return frame.ToArray();
}
