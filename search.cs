var conn = new ActiveXObject("ADODB.Connection");
var rs = new ActiveXObject("ADODB.Recordset");

var dbPath = "C:\\path\\to\\your\\database.accdb";
var connStr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + dbPath;

conn.Open(connStr);
rs.Open("SELECT * FROM YourTable", conn);

while (!rs.EOF) {
    console.log(rs.Fields(0).Value); // Print first column value
    rs.MoveNext();
}

rs.Close();
conn.Close();
