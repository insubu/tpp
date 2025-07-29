Sub SelectCleanSaveFile_UTF8Out()
    Dim fd As FileDialog
    Dim filePath As String, newFilePath As String
    Dim fso As Object, tsIn As Object
    Dim line As String, cleanedLine As String
    Dim re As Object
    Dim lineCount As Long
    Dim outputBuffer As String
    Dim encodingCode As Long

    ' Select file
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

    ' Regex setup
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"
    End With

    ' Read lines
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tsIn = fso.OpenTextFile(filePath, 1, False, -1) ' UTF-8 with BOM assumed

    outputBuffer = ""
    Do Until tsIn.AtEndOfStream
        line = tsIn.ReadLine
        cleanedLine = re.Replace(line, "")
        outputBuffer = outputBuffer & cleanedLine & vbCrLf
        lineCount = lineCount + 1
    Loop
    tsIn.Close

    ' Write with UTF-8 using ADODB.Stream
    Dim stream As Object
    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Charset = "utf-8"
        .Open
        .WriteText outputBuffer
        .SaveToFile newFilePath, 2 ' 2 = overwrite
        .Close
    End With

    MsgBox "Saved " & lineCount & " cleaned lines to:" & vbCrLf & newFilePath
End Sub
