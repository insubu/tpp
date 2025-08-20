Sub ImportCSV_Fast()
    Dim ws As Worksheet
    Dim csvPath As String
    
    csvPath = "C:\temp\bigdata.csv"
    Set ws = ThisWorkbook.Sheets(1)
    
    ' Clear existing
    ws.Cells.Clear
    
    ' Add QueryTable (text file as source)
    With ws.QueryTables.Add(Connection:="TEXT;" & csvPath, Destination:=ws.Range("A1"))
        .TextFileParseType = xlDelimited
        .TextFileCommaDelimiter = True
        .TextFilePlatform = 65001    ' UTF-8
        .PreserveFormatting = True
        .AdjustColumnWidth = False
        .Refresh BackgroundQuery:=False
    End With
End Sub

Sub ImportCSV_ODBC()
    Dim ws As Worksheet
    Dim conn As Object, rs As Object
    Dim csvPath As String, sql As String
    
    csvPath = "C:\temp\"
    Set ws = ThisWorkbook.Sheets(1)
    ws.Cells.Clear
    
    ' ODBC connection to text file folder
    Set conn = CreateObject("ADODB.Connection")
    conn.Open "Driver={Microsoft Text Driver (*.txt; *.csv)};Dbq=" & csvPath & ";Extensions=csv;"
    
    sql = "SELECT * FROM [bigdata.csv]"
    Set rs = conn.Execute(sql)
    
    ws.Range("A1").CopyFromRecordset rs
    
    rs.Close
    conn.Close
End Sub
