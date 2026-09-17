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

    If ActiveSheet.Name <> "Admin Panel" Then
        MsgBox "Go to the Admin Panel sheet first, then select a user row."
        Exit Sub
    End If

    If ActiveCell.Row < 2 Or ws.Cells(ActiveCell.Row, 1).Value = "" Then
        MsgBox "Select a row containing a user (click anywhere in that row), then click Deactivate."
        Exit Sub
    End If

    Dim userId As Long
    Dim targetUsername As String
    userId = ws.Cells(ActiveCell.Row, 1).Value
    targetUsername = ws.Cells(ActiveCell.Row, 2).Value

    If MsgBox("Deactivate user '" & targetUsername & "' (ID " & userId & ")?", vbYesNo) = vbYes Then
        If mAdminPanel.DeactivateUser(userId) Then
            mRibbon.RefreshAdminUsersSheet
            MsgBox "User deactivated."
        Else
            MsgBox "Deactivation failed — check that your session hasn't expired (try logging in again if this persists)."
        End If
    End If
End Sub


Sub OnReactivateClick(control As IRibbonControl)
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    If ActiveSheet.Name <> "Admin Panel" Then
        MsgBox "Go to the Admin Panel sheet first, then select a user row."
        Exit Sub
    End If

    If ActiveCell.Row < 2 Or ws.Cells(ActiveCell.Row, 1).Value = "" Then
        MsgBox "Select a row containing a user (click anywhere in that row), then click Reactivate."
        Exit Sub
    End If

    Dim userId As Long
    Dim targetUsername As String
    userId = ws.Cells(ActiveCell.Row, 1).Value
    targetUsername = ws.Cells(ActiveCell.Row, 2).Value

    Dim newPassword As String
    newPassword = InputBox("Enter a new password for '" & targetUsername & "':")

    If newPassword = "" Then Exit Sub

    If mAdminPanel.ReactivateUser(userId, newPassword) Then
        mRibbon.RefreshAdminUsersSheet
        MsgBox "User '" & targetUsername & "' reactivated."
    Else
        MsgBox "Reactivation failed — check that your session hasn't expired (try logging in again if this persists)."
    End If
End Sub

Sub OnAddUserClick(control As IRibbonControl)
    frmAddUser.Show vbModal
End Sub
