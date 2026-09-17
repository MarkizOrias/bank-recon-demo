Attribute VB_Name = "mRibbon"
'--------------------------
' ADMIN                   |
'--------------------------
Public MyRibbon As IRibbonUI

Sub RibbonOnLoad(ribbon As IRibbonUI)
    Set MyRibbon = ribbon
End Sub

Sub GetAdminTabVisible(control As IRibbonControl, ByRef visible)
    visible = (mAuth.CurrentRole = "admin")
End Sub


Public Sub RefreshAdminUsersSheet()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    If lastRow > 1 Then
        ws.Range("A2:F" & lastRow).ClearContents
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
        ws.Cells(r, 6).Value = u("must_change_password")
        r = r + 1
    Next u

    ws.Columns("A:F").AutoFit

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

    Dim tempPassword As String
    If mAdminPanel.ReactivateUser(userId, tempPassword) Then
        mRibbon.RefreshAdminUsersSheet
        frmTempPassword.Display "User '" & targetUsername & "' reactivated. Share this temporary password securely — it must be changed on first login:", tempPassword
        frmTempPassword.Show vbModal
    Else
        MsgBox "Reactivation failed."
    End If
End Sub

Sub OnAddUserClick(control As IRibbonControl)
    frmAddUser.Show vbModal
End Sub

'--------------------------
' RECONCILER              |
'--------------------------
Sub GetReconTabVisible(control As IRibbonControl, ByRef visible)
    visible = (mAuth.CurrentRole = "reconciler")
End Sub

'--------------------------
' SHARED / ACCOUNT        |
'--------------------------
Sub OnChangePasswordClick(control As IRibbonControl)
    frmChangePassword.ShowForm False
End Sub

