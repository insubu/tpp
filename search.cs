var conn = new ActiveXObject("ADODB.Connection");
var cmd = new ActiveXObject("ADODB.Command");

var dbPath = "C:\\path\\to\\your\\database.accdb";
var connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + dbPath;

conn.Open(connStr);
cmd.ActiveConnection = conn;
cmd.CommandText = "SELECT * FROM YourTable WHERE Name = ? AND Age = ?";

// Define parameters
cmd.Parameters.Append(cmd.CreateParameter("?", 202, 1, 255, "Alice")); // adVarWChar
cmd.Parameters.Append(cmd.CreateParameter("?", 3, 1, , 30)); // adInteger

var rs = cmd.Execute();

while (!rs.EOF) {
    console.log(rs.Fields(0).Value); // Print first column value
    rs.MoveNext();
}

rs.Close();
conn.Close();
