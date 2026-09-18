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

'Navigate through matched breaks
Public Sub RefreshClosedBreaksSheet()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Closed Breaks")

    ws.Cells.Clear

    ws.Cells(1, 1).Value = "Match ID"
    ws.Cells(1, 2).Value = "Proposed By"
    ws.Cells(1, 3).Value = "Approved By"
    ws.Cells(1, 4).Value = "Approved At"
    ws.Cells(1, 5).Value = "Variance"
    ws.Cells(1, 6).Value = "Side"
    ws.Cells(1, 7).Value = "Reference"
    ws.Cells(1, 8).Value = "Amount"
    ws.Cells(1, 9).Value = "Currency"
    ws.Range("A1:I1").Font.Bold = True
    ws.Columns("A:I").AutoFit

    Dim closed As Collection
    Set closed = mAdminPanel.GetClosedMatches()

    If closed.Count = 0 Then
        ws.Cells(2, 1).Value = "No closed matches."
        Exit Sub
    End If

    Dim m As Dictionary
    Dim rec As Dictionary
    Dim r As Long
    r = 2

    For Each m In closed
        Dim records As Collection
        Set records = m("records")

        For Each rec In records
            ws.Cells(r, 1).Value = m("matchId")
            ws.Cells(r, 2).Value = m("proposedBy")
            ws.Cells(r, 3).Value = m("approvedBy")
            ws.Cells(r, 4).Value = m("approvedAt")
            ws.Cells(r, 5).Value = m("amountVariance")
            ws.Cells(r, 6).Value = rec("side")
            ws.Cells(r, 7).Value = rec("reference")
            ws.Cells(r, 8).Value = rec("amount")
            ws.Cells(r, 9).Value = rec("currency")
            r = r + 1
        Next rec
    Next m

    ws.Columns("A:I").AutoFit
End Sub

'Reopening breaks functionality
Sub OnChangeReopenBreak(control As IRibbonControl)
    If ActiveSheet.Name <> "Closed Breaks" Then
        MsgBox "Go to the Closed Breaks sheet first, then select a row belonging to the match you want to reopen."
        Exit Sub
    End If

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Closed Breaks")

    Dim matchIdCol As Long
    matchIdCol = FindColumnByHeader(ws, "Match ID")
    If matchIdCol = 0 Then
        MsgBox "Could not find the Match ID column on this sheet."
        Exit Sub
    End If

    If ActiveCell.Row < 2 Or ws.Cells(ActiveCell.Row, matchIdCol).Value = "" Then
        MsgBox "Select a row containing a closed match first."
        Exit Sub
    End If

    Dim matchId As Long
    matchId = ws.Cells(ActiveCell.Row, matchIdCol).Value

    If MsgBox("Reopen match ID " & matchId & "? Its records will return to Open Breaks for re-reconciliation.", vbYesNo) = vbYes Then
        If mAdminPanel.ReopenMatch(matchId) Then
            mRibbon.RefreshAdminUsersSheet
            mRibbon.RefreshClosedBreaksSheet
            MsgBox "Match reopened."
        Else
            MsgBox "Reopen failed — the match may no longer be approved, or may have already been reopened."
        End If
    End If
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

Sub OnRefreshReconClick(control As IRibbonControl)
    mReconciler.RefreshOpenBreaks
    mReconciler.RefreshMatchingQueue
End Sub

Sub OnProposeMatchClick(control As IRibbonControl)
    If ActiveSheet.Name <> "Open Breaks" Then
        MsgBox "Go to the Open Breaks sheet first, then select two or more records to propose a match."
        Exit Sub
    End If

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Open Breaks")

    Dim idCol As Long
    idCol = FindColumnByHeader(ws, "ID")
    If idCol = 0 Then
        MsgBox "Could not find an ID column on this sheet."
        Exit Sub
    End If

    Dim selectedIds As Object
    Set selectedIds = CreateObject("Scripting.Dictionary")

    Dim area As Range
    Dim cell As Range
    For Each area In Selection.Areas
        For Each cell In area.Rows
            If cell.Row >= 2 Then
                Dim idValue As Long
                idValue = ws.Cells(cell.Row, idCol).Value
                If idValue > 0 Then
                    If Not selectedIds.Exists(idValue) Then
                        selectedIds.Add idValue, True
                    End If
                End If
            End If
        Next cell
    Next area

    If selectedIds.Count < 2 Then
        MsgBox "Select at least two records (Ctrl+Click across rows) — at least one internal and one external."
        Exit Sub
    End If

    Dim idCollection As New Collection
    Dim k As Variant
    For Each k In selectedIds.keys
        idCollection.Add CLng(k)
    Next k

    If MsgBox("Propose a match for " & idCollection.Count & " selected record(s)?", vbYesNo) = vbYes Then
        If mReconciler.ProposeMatch(idCollection) Then
            mReconciler.RefreshOpenBreaks
            mReconciler.RefreshMatchingQueue
            MsgBox "Match proposed successfully."
        Else
            MsgBox "Failed to propose match — check that all selected records are still unmatched and share a currency, with at least one internal and one external record."
        End If
    End If
End Sub

Sub OnApproveMatchClick(control As IRibbonControl)
    HandleMatchDecision True
End Sub

Sub OnRejectMatchClick(control As IRibbonControl)
    HandleMatchDecision False
End Sub

Private Sub HandleMatchDecision(ByVal isApprove As Boolean)
    If ActiveSheet.Name <> "Matching Queue" Then
        MsgBox "Go to the Matching Queue sheet first, then select a row belonging to the match you want to " & IIf(isApprove, "approve", "reject") & "."
        Exit Sub
    End If

    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Matching Queue")

    If ActiveCell.Row < 2 Or ws.Cells(ActiveCell.Row, 1).Value = "" Then
        MsgBox "Select a row containing a proposed match first."
        Exit Sub
    End If

    Dim matchId As Long
    Dim proposedBy As String
    matchId = ws.Cells(ActiveCell.Row, 1).Value
    proposedBy = ws.Cells(ActiveCell.Row, 2).Value

    Dim actionWord As String
    actionWord = IIf(isApprove, "Approve", "Reject")

    If MsgBox(actionWord & " match ID " & matchId & " (proposed by '" & proposedBy & "')?", vbYesNo) = vbYes Then
        Dim success As Boolean
        If isApprove Then
            success = mReconciler.ApproveMatch(matchId)
        Else
            success = mReconciler.RejectMatch(matchId)
        End If

        If success Then
            mReconciler.RefreshOpenBreaks
            mReconciler.RefreshMatchingQueue
            MsgBox "Match " & LCase(actionWord) & "d."
        Else
            MsgBox actionWord & " failed — you may not be allowed to " & LCase(actionWord) & " your own proposed match, or it may no longer be pending."
        End If
    End If
End Sub

Private Function FindColumnByHeader(ByVal ws As Worksheet, ByVal headerText As String) As Long
    Dim c As Long
    For c = 1 To ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
        If ws.Cells(1, c).Value = headerText Then
            FindColumnByHeader = c
            Exit Function
        End If
    Next c
    FindColumnByHeader = 0
End Function

'--------------------------
' SHARED / ACCOUNT        |
'--------------------------
Sub OnChangePasswordClick(control As IRibbonControl)
    frmChangePassword.ShowForm False
End Sub

