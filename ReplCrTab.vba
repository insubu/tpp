Sub SelectAndReadFile()
    Dim fd As FileDialog
    Dim filePath As String
    Dim fso As Object
    Dim ts As Object
    Dim line As String
    Dim re As Object
    Dim cleanedLine As String
    Dim lineCount As Long

    ' Ask user to pick a file
    Set fd = Application.FileDialog(msoFileDialogFilePicker)
    With fd
        .Title = "Select a text file"
        .Filters.Clear
        .Filters.Add "Text Files", "*.txt"
        .AllowMultiSelect = False
        If .Show <> -1 Then Exit Sub ' Cancelled
        filePath = .SelectedItems(1)
    End With

    ' Prepare regex: remove lone \r and tabs
    Set re = CreateObject("VBScript.RegExp")
    With re
        .Global = True
        .Pattern = "\r(?!\n)|\t"
    End With

    ' Read the file line by line
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set ts = fso.OpenTextFile(filePath, 1, False, -1) ' UTF-8 with BOM

    Do Until ts.AtEndOfStream
        line = ts.ReadLine
        cleanedLine = re.Replace(line, "")
        lineCount = lineCount + 1

        ' Example output
        Debug.Print cleanedLine
    Loop

    ts.Close
    MsgBox "Total lines processed: " & lineCount
End Sub
