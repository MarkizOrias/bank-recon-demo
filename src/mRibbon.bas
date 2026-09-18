Attribute VB_Name = "mRibbon"
'--------------------------
' ADMIN                   |
'--------------------------
Public MyRibbon As IRibbonUI

'Declare custom RibbonX object
Sub RibbonOnLoad(ribbon As IRibbonUI)
    Set MyRibbon = ribbon
End Sub

'Show custom RibbonX when role is admin
Sub GetAdminTabVisible(control As IRibbonControl, ByRef visible)
    visible = (mAuth.CurrentRole = "admin")
End Sub

'Users table DB grid filler
Public Sub RefreshAdminUsersSheet()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")

    'Clear content incl formatting
    ws.Cells.Clear

    'Query DB Users table
    Dim users As Collection
    Set users = mAdminPanel.GetUsers()

    'Count Users
    If users.Count = 0 Then
        ws.Cells(1, 1).Value = "No users found."
        Exit Sub
    End If

    'Take first user from the table
    Dim firstUser As Dictionary
    Set firstUser = users(1)

    'Take headers from that record
    Dim keys As Variant
    keys = firstUser.keys

    'Assign number of headers to colum count, adjust for index 0
    Dim colCount As Long
    colCount = UBound(keys) - LBound(keys) + 1

    'Fill column headers with values, bold them
    Dim c As Long
    For c = 0 To UBound(keys)
        ws.Cells(1, c + 1).Value = FormatHeaderLabel(CStr(keys(c)))
    Next c
    ws.Range(ws.Cells(1, 1), ws.Cells(1, colCount)).Font.Bold = True

    Dim u As Dictionary
    Dim r As Long
    r = 2

    'Loop through users and fill data grid beneath headers
    For Each u In users
        For c = 0 To UBound(keys)
            ws.Cells(r, c + 1).Value = u(keys(c))
        Next c
        r = r + 1
    Next u
    
    'Adjust cells width
    ws.Range(ws.Cells(1, 1), ws.Cells(r - 1, colCount)).Columns.AutoFit
    
End Sub

'Normalize text formatting (without underscore)
Private Function FormatHeaderLabel(ByVal rawKey As String) As String
    If rawKey = "id" Then
        FormatHeaderLabel = "ID"
        Exit Function
    End If

    Dim words() As String
    words = Split(rawKey, "_")

    Dim i As Long
    For i = LBound(words) To UBound(words)
        words(i) = UCase(Left(words(i), 1)) & Mid(words(i), 2)
    Next i

    FormatHeaderLabel = Join(words, " ")
End Function

'Call filling datagrid function
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

