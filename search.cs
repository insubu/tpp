using System;
using System.Data.OleDb;

class Program
{
    static void Main()
    {
        string connectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\path\to\your\database.accdb;";
        using (OleDbConnection connection = new OleDbConnection(connectionString))
        {
            connection.Open();
            Console.WriteLine("Connected to Access database.");
        }
    }
}

string query = "INSERT INTO Users (Name, Age) VALUES (?, ?)";
using (OleDbCommand command = new OleDbCommand(query, connection))
{
    command.Parameters.AddWithValue("@Name", "Alice");
    command.Parameters.AddWithValue("@Age", 30);
    command.ExecuteNonQuery();
}
string query = "SELECT * FROM Users";
using (OleDbCommand command = new OleDbCommand(query, connection))
using (OleDbDataReader reader = command.ExecuteReader())
{
    while (reader.Read())
    {
        Console.WriteLine($"ID: {reader["ID"]}, Name: {reader["Name"]}, Age: {reader["Age"]}");
    }
}

string query = "UPDATE Users SET Age = ? WHERE Name = ?";
using (OleDbCommand command = new OleDbCommand(query, connection))
{
    command.Parameters.AddWithValue("@Age", 35);
    command.Parameters.AddWithValue("@Name", "Alice");
    command.ExecuteNonQuery();
}
