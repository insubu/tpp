Sub StreamCleanSave_UTF8_Block()

    Const BLOCK_SIZE As Long = 5000
    Dim inputStream As Object, outputStream As Object
    Dim re As Object
    Dim buffer As String, cleanedLine As String
    Dim filePath As String, newFilePath As String
    Dim lineCount As Long, bufferLineCount As Long

    ' === File Picker ===
    With Application.FileDialog(msoFileDialogFilePicker)
        .Title = "Select CSV or TXT file"
        .Filters.Clear
        .Filters.Add "CSV/TXT Files", "*.csv;*.txt"
        If .Show <> -1 Then Exit Sub
        filePath = .SelectedItems(1)
    End With

    ' === Output file path ===
    Dim dotPos As Long
    dotPos = InStrRev(filePath, ".")
    If dotPos > 0 Then
        newFilePath = Left(filePath, dotPos - 1) & "_cleaned" & Mid(filePath, dotPos)
    Else
        newFilePath = filePath & "_cleaned.txt"
    End If

    ' === RegExp setup ===
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"  ' remove lone \r and tabs
    End With

    ' === Open input stream ===
    Set inputStream = CreateObject("ADODB.Stream")
    With inputStream
        .Charset = "utf-8"
        .Open
        .LoadFromFile filePath
        .Position = 0
        .Type = 2 ' adText
    End With

    ' === Open output stream ===
    Set outputStream = CreateObject("ADODB.Stream")
    With outputStream
        .Charset = "utf-8"
        .Open
        .Type = 2 ' adText
    End With

    ' === Read line-by-line, block write ===
    buffer = ""
    bufferLineCount = 0

    Do While Not inputStream.EOS
        cleanedLine = re.Replace(inputStream.ReadText(-2), "")  ' -2 = read line
        buffer = buffer & cleanedLine & vbCrLf
        bufferLineCount = bufferLineCount + 1
        lineCount = lineCount + 1

        If bufferLineCount >= BLOCK_SIZE Then
            outputStream.WriteText buffer
            buffer = ""
            bufferLineCount = 0
        End If
    Loop

    If buffer <> "" Then outputStream.WriteText buffer

    ' === Save output ===
    outputStream.SaveToFile newFilePath, 2
    inputStream.Close
    outputStream.Close

    MsgBox "Saved " & lineCount & " lines to:" & vbCrLf & newFilePath, vbInformation

End Sub
