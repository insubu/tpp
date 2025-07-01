Sub UpdateLastRange()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim rng As Range
    Dim nm As Name

    Set ws = ThisWorkbook.Sheets("Sheet1") ' Change to your sheet name
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    Set rng = ws.Range("A1:A" & lastRow)

    ' Delete existing name if it exists
    On Error Resume Next
    ThisWorkbook.Names("lastrng").Delete
    On Error GoTo 0

    ' Create new named range
    ThisWorkbook.Names.Add Name:="lastrng", RefersTo:=rng
End Sub
