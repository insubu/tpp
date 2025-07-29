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

' Write UTF-8 file without BOM
Sub SaveUTF8WithoutBOM(ByVal text As String, ByVal filePath As String)
    Dim stream As Object

    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Charset = "utf-8"
        .Type = 2 ' Text mode
        .Open
        .WriteText text
        .Position = 0
        .Type = 1 ' Binary mode
        .Position = 3 ' Skip BOM
        .SaveToFile filePath, 2 ' Overwrite
        .Close
    End With
End Sub
