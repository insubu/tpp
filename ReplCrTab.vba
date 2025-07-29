Sub SelectCleanSaveFile()
    Dim fd As FileDialog
    Dim filePath As String, newFilePath As String
    Dim fso As Object, tsIn As Object, tsOut As Object
    Dim line As String, cleanedLine As String
    Dim re As Object
    Dim lineCount As Long

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

    ' Prepare output path: "example.csv" → "example_cleaned.csv"
    Dim dotPos As Long
    dotPos = InStrRev(filePath, ".")
    If dotPos > 0 Then
        newFilePath = Left(filePath, dotPos - 1) & "_cleaned" & Mid(filePath, dotPos)
    Else
        newFilePath = filePath & "_cleaned.txt"
    End If

    ' Create regex
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"
    End With

    ' FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set tsIn = fso.OpenTextFile(filePath, 1, False, -1)   ' Read, UTF-8 BOM
    Set tsOut = fso.CreateTextFile(newFilePath, True, True) ' Write, UTF-8 BOM

    ' Process line-by-line
    Do Until tsIn.AtEndOfStream
        line = tsIn.ReadLine
        cleanedLine = re.Replace(line, "")
        tsOut.WriteLine cleanedLine
        lineCount = lineCount + 1
    Loop

    tsIn.Close
    tsOut.Close

    MsgBox "Saved " & lineCount & " cleaned lines to:" & vbCrLf & newFilePath
End Sub
