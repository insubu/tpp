Sub SelectCleanSaveFile_UTF8_BlockWrite()
    Const BLOCK_SIZE As Long = 5000
    Dim fd As FileDialog
    Dim filePath As String, newFilePath As String
    Dim fso As Object, tsIn As Object
    Dim line As String, cleanedLine As String
    Dim re As Object
    Dim lineCount As Long, bufferLineCount As Long
    Dim buffer As String
    Dim stream As Object

    ' File select
    Set fd = Application.FileDialog(msoFileDialogFilePicker)
    With fd
        .Title = "Select a CSV or TXT file"
        .Filters.Clear
        .Filters.Add "CSV and Text Files", "*.csv;*.txt"
        .AllowMultiSelect = False
        If .Show <> -1 Then Exit Sub
        filePath = .SelectedItems(1)
    End With

    ' Output path
    Dim dotPos As Long
    dotPos = InStrRev(filePath, ".")
    If dotPos > 0 Then
        newFilePath = Left(filePath, dotPos - 1) & "_cleaned" & Mid(filePath, dotPos)
    Else
        newFilePath = filePath & "_cleaned.txt"
    End If

    ' Regex
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"
    End With

    ' Input stream
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tsIn = fso.OpenTextFile(filePath, 1, False, -1)

    ' Output ADODB stream
    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Charset = "utf-8"
        .Open
    End With

    ' Main loop
    buffer = ""
    bufferLineCount = 0
    Do Until tsIn.AtEndOfStream
        line = tsIn.ReadLine
        cleanedLine = re.Replace(line, "")
        buffer = buffer & cleanedLine & vbCrLf
        bufferLineCount = bufferLineCount + 1
        lineCount = lineCount + 1

        If bufferLineCount >= BLOCK_SIZE Then
            stream.WriteText buffer
            buffer = ""
            bufferLineCount = 0
        End If
    Loop

    ' Write any remaining lines
    If buffer <> "" Then
        stream.WriteText buffer
    End If

    tsIn.Close
    stream.SaveToFile newFilePath, 2
    stream.Close

    MsgBox "Saved " & lineCount & " cleaned lines to:" & vbCrLf & newFilePath
End Sub
