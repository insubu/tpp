Sub CleanFile_RemoveTabs_CarriageReturns()
    Dim fd As FileDialog
    Dim filePath As String, newFilePath As String
    Dim stream As Object
    Dim line As String, cleanedLine As String
    Dim buffer As String
    Dim re As Object
    Dim lineCount As Long

    ' File selection
    Set fd = Application.FileDialog(msoFileDialogFilePicker)
    With fd
        .Title = "Select a CSV or TXT file"
        .Filters.Clear
        .Filters.Add "CSV and Text Files", "*.csv;*.txt"
        .AllowMultiSelect = False
        If .Show <> -1 Then Exit Sub
        filePath = .SelectedItems(1)
    End With

    ' Output file path
    Dim dotPos As Long
    dotPos = InStrRev(filePath, ".")
    If dotPos > 0 Then
        newFilePath = Left(filePath, dotPos - 1) & "_cleaned" & Mid(filePath, dotPos)
    Else
        newFilePath = filePath & "_cleaned.txt"
    End If

    ' Set up regex
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"
    End With

    ' Open ADODB.Stream for input
    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Charset = "utf-8"
        .Type = 2 ' Text mode
        .Open
        .LoadFromFile filePath
    End With

    ' Read line by line and clean
    Do While Not stream.EOS
        line = stream.ReadText(-2) ' ReadLine
        cleanedLine = re.Replace(line, "")
        buffer = buffer & cleanedLine & vbCrLf
        lineCount = lineCount + 1
    Loop
    stream.Close

    ' Write output without BOM
    Call SaveUTF8WithoutBOM(buffer, newFilePath)

    MsgBox "Cleaned " & lineCount & " lines to:" & vbCrLf & newFilePath
End Sub

Function ByteArraySlice(ByRef arr() As Byte, ByVal startIndex As Long) As Byte()
    Dim result() As Byte
    Dim length As Long
    length = UBound(arr) - startIndex + 1
    ReDim result(0 To length - 1)
    Dim i As Long
    For i = 0 To length - 1
        result(i) = arr(startIndex + i)
    Next i
    ByteArraySlice = result
End Function

Sub SaveUTF8WithoutBOM(text As String, filePath As String)
    Dim utf8Stream As Object
    Dim noBOMStream As Object
    Dim bytes() As Byte
    Dim noBOMBytes() As Byte
    Const BOM_LENGTH As Long = 3

    ' Write text with BOM first
    Set utf8Stream = CreateObject("ADODB.Stream")
    With utf8Stream
        .Charset = "utf-8"
        .Open
        .WriteText text
        .Position = 0
        .Type = 1 ' Binary mode
        bytes = .Read
        .Close
    End With

    ' Extract bytes excluding BOM
    noBOMBytes = ByteArraySlice(bytes, BOM_LENGTH)

    ' Write bytes without BOM to new stream
    Set noBOMStream = CreateObject("ADODB.Stream")
    With noBOMStream
        .Type = 1 ' Binary
        .Open
        .Write noBOMBytes
        .SaveToFile filePath, 2 ' overwrite
        .Close
    End With
End Sub

