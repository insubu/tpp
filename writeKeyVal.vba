Sub WriteKeyVal(key As String, val As Variant)
    Dim wb As Workbook
    Dim rng As Range
    Dim lastAddrRng As Range
    
    Set wb = ThisWorkbook
    
    On Error Resume Next
    Set rng = wb.Names(key).RefersToRange
    On Error GoTo 0

    ' 如果 key 不存在，则使用 lastAddress 分配一个位置
    If rng Is Nothing Then
        On Error Resume Next
        Set lastAddrRng = wb.Names("lastAddress").RefersToRange
        On Error GoTo 0
        
        If lastAddrRng Is Nothing Then
            ' 默认使用第一个工作表的 A1
            Set lastAddrRng = wb.Sheets(1).Range("A1")
            wb.Names.Add Name:="lastAddress", RefersTo:=lastAddrRng
        End If
        
        Set rng = lastAddrRng.Offset(1, 0)
        wb.Names.Add Name:=key, RefersTo:=rng
    End If

    ' 设置值
    rng.Value = val
    
    ' 更新 lastAddress 为当前 key 的位置
    On Error Resume Next
    wb.Names("lastAddress").Delete
    On Error GoTo 0
    wb.Names.Add Name:="lastAddress", RefersTo:=rng
End Sub
