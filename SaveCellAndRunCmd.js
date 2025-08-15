Sub SaveCellAndRunCmd()
    Dim fso As Object
    Dim tmpFile As String
    Dim cellValue As String
    Dim wsh As Object
    Dim cmd As String
    
    ' Get the value from a specific cell
    cellValue = ThisWorkbook.Sheets("Sheet1").Range("A1").Value
    
    ' Create FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Create temporary file path
    tmpFile = Environ("TEMP") & "\temp.txt"
    
    ' Write the cell value to the temp file
    Dim file As Object
    Set file = fso.CreateTextFile(tmpFile, True)
    file.Write cellValue
    file.Close
    
    ' Build the external command
    ' Example: myprogram.exe "C:\Temp\temp.txt"
    cmd = "C:\Path\To\YourProgram.exe """ & tmpFile & """"
    
    ' Create WScript.Shell to run the command
    Set wsh = CreateObject("WScript.Shell")
    wsh.Run cmd, 1, True   ' 1 = normal window, True = wait until finished
    
    ' Optional: notify user
    MsgBox "Command executed with temp file: " & tmpFile, vbInformation
End Sub
