Attribute VB_Name = "mRibbon"
Public Sub RefreshAdminUsersSheet()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    If lastRow > 1 Then
        ws.Range("A2:E" & lastRow).ClearContents
    End If

    Dim users As Collection
    Set users = mAdminPanel.GetUsers()

    Dim u As Dictionary
    Dim r As Long
    r = 2

    For Each u In users
        ws.Cells(r, 1).Value = u("id")
        ws.Cells(r, 2).Value = u("username")
        ws.Cells(r, 3).Value = u("role")
        ws.Cells(r, 4).Value = u("active")
        ws.Cells(r, 5).Value = u("created_at")
        r = r + 1
    Next u
    
    ws.Columns("A:E").AutoFit
    
End Sub
Sub OnRefreshClick(control As IRibbonControl)
    mRibbon.RefreshAdminUsersSheet
End Sub

Sub OnDeactivateClick(control As IRibbonControl)
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    If ActiveSheet.Name <> "Admin Panel" Or ActiveCell.Row < 2 Then
        MsgBox "Select a user row on the Admin Panel sheet first."
        Exit Sub
    End If

    Dim userId As Long
    userId = ws.Cells(ActiveCell.Row, 1).Value

    If MsgBox("Deactivate user ID " & userId & "?", vbYesNo) = vbYes Then
        If mAdminPanel.DeactivateUser(userId) Then
            mAdminPanel.RefreshAdminUsersSheet
        Else
            MsgBox "Deactivation failed."
        End If
    End If
End Sub

Sub OnReactivateClick(control As IRibbonControl)
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    If ActiveSheet.Name <> "Admin Panel" Or ActiveCell.Row < 2 Then
        MsgBox "Select a user row on the Admin Panel sheet first."
        Exit Sub
    End If

    Dim userId As Long
    userId = ws.Cells(ActiveCell.Row, 1).Value

    Dim newPassword As String
    newPassword = InputBox("Enter a new password for this user:")

    If newPassword = "" Then Exit Sub

    If mAdminPanel.ReactivateUser(userId, newPassword) Then
        mAdminPanel.RefreshAdminUsersSheet
    Else
        MsgBox "Reactivation failed."
    End If
End Sub

Sub OnAddUserClick(control As IRibbonControl)
    MsgBox "TODO: open Add User form"
End Sub
