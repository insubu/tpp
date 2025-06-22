#If VBA7 Then
    Private Declare PtrSafe Function sqlite3_open Lib "sqlite3.dll" (ByVal dbName As String, ByRef db As LongPtr) As Long
    Private Declare PtrSafe Function sqlite3_close Lib "sqlite3.dll" (ByVal db As LongPtr) As Long
    Private Declare PtrSafe Function sqlite3_prepare_v2 Lib "sqlite3.dll" (ByVal db As LongPtr, ByVal zSql As String, ByVal nByte As Long, ByRef stmt As LongPtr, ByVal pzTail As LongPtr) As Long
    Private Declare PtrSafe Function sqlite3_step Lib "sqlite3.dll" (ByVal stmt As LongPtr) As Long
    Private Declare PtrSafe Function sqlite3_column_text Lib "sqlite3.dll" (ByVal stmt As LongPtr, ByVal iCol As Long) As LongPtr
    Private Declare PtrSafe Function sqlite3_finalize Lib "sqlite3.dll" (ByVal stmt As LongPtr) As Long
    Private Declare PtrSafe Function lstrlenA Lib "kernel32" (ByVal lpString As LongPtr) As Long
    Private Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByVal Source As LongPtr, ByVal Length As Long)
#End If

Sub ReadSQLiteDirect()
    Dim db As LongPtr, stmt As LongPtr
    Dim rc As Long, sql As String
    Dim txtPtr As LongPtr, txtLen As Long
    Dim result As String

    rc = sqlite3_open("C:\path\to\your.db", db)
    If rc <> 0 Then MsgBox "Failed to open DB": Exit Sub

    sql = "SELECT name FROM sqlite_master WHERE type='table';"
    rc = sqlite3_prepare_v2(db, sql, Len(sql), stmt, 0)
    If rc <> 0 Then MsgBox "Prepare failed": GoTo CleanUp

    Do While sqlite3_step(stmt) = 100 ' SQLITE_ROW
        txtPtr = sqlite3_column_text(stmt, 0)
        txtLen = lstrlenA(txtPtr)
        result = Space$(txtLen)
        CopyMemory ByVal StrPtr(result), txtPtr, txtLen
        Debug.Print result
    Loop

CleanUp:
    sqlite3_finalize stmt
    sqlite3_close db
End Sub
