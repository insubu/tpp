using System;
using System.IO;
using System.Text.RegularExpressions;

class Program
{
    static void Main()
    {
        string filePath = @"your_file.txt"; // 🔁 Put your file path here

        if (!File.Exists(filePath))
        {
            Console.WriteLine("File not found.");
            return;
        }

        string content = File.ReadAllText(filePath);

        // Regex: from line starting with 'key:case' to line with "as '...'"
        string pattern = @"^key:case.*?^.*as\s+'.*'";
        var matches = Regex.Matches(content, pattern, RegexOptions.Multiline | RegexOptions.Singleline);

        foreach (Match match in matches)
        {
            Console.WriteLine("=== Block ===");
            Console.WriteLine(match.Value);
            Console.WriteLine();
        }
    }
}
