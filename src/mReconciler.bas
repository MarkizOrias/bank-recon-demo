Attribute VB_Name = "mReconciler"
Option Explicit

Public Sub SetupReconciliationSheets()
    Dim ws As Worksheet
    Dim found As Boolean

    found = False
    For Each ws In ThisWorkbook.Sheets
        If ws.Name = "Open Breaks" Then
            found = True
            Exit For
        End If
    Next ws
    If Not found Then
        Set ws = ThisWorkbook.Sheets.Add(Before:=ThisWorkbook.Sheets(1))
        ws.Name = "Open Breaks"
    End If

    found = False
    For Each ws In ThisWorkbook.Sheets
        If ws.Name = "Matching Queue" Then
            found = True
            Exit For
        End If
    Next ws
    If Not found Then
        Set ws = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets("Open Breaks"))
        ws.Name = "Matching Queue"
    End If

    ThisWorkbook.Sheets("Open Breaks").Activate

    RefreshOpenBreaks
    RefreshMatchingQueue
End Sub


Public Sub RefreshOpenBreaks()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Open Breaks")

    ws.Cells.Clear

    Dim breaks As Collection
    Set breaks = mReconciler.GetOpenBreaks()

    If breaks.Count = 0 Then
        ws.Cells(1, 1).Value = "No open breaks."
        Exit Sub
    End If

    Dim firstRecord As Dictionary
    Set firstRecord = breaks(1)

    Dim keys As Variant
    keys = firstRecord.keys

    Dim colCount As Long
    colCount = UBound(keys) - LBound(keys) + 1

    Dim c As Long
    For c = 0 To UBound(keys)
        ws.Cells(1, c + 1).Value = FormatHeaderLabel(CStr(keys(c)))
    Next c
    ws.Range(ws.Cells(1, 1), ws.Cells(1, colCount)).Font.Bold = True

    Dim rec As Dictionary
    Dim r As Long
    r = 2

    For Each rec In breaks
        For c = 0 To UBound(keys)
            ws.Cells(r, c + 1).Value = rec(keys(c))
        Next c
        r = r + 1
    Next rec

    ws.Range(ws.Cells(1, 1), ws.Cells(r - 1, colCount)).Columns.AutoFit
End Sub

Public Sub RefreshMatchingQueue()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Matching Queue")

    ws.Cells.Clear

    ws.Cells(1, 1).Value = "Match ID"
    ws.Cells(1, 2).Value = "Proposed By"
    ws.Cells(1, 3).Value = "Matched At"
    ws.Cells(1, 4).Value = "Variance"
    ws.Cells(1, 5).Value = "Side"
    ws.Cells(1, 6).Value = "Reference"
    ws.Cells(1, 7).Value = "Amount"
    ws.Cells(1, 8).Value = "Currency"
    ws.Range("A1:H1").Font.Bold = True
     ws.Columns("A:H").AutoFit

    Dim queue As Collection
    Set queue = mReconciler.GetMatchingQueue()

    If queue.Count = 0 Then
        ws.Cells(2, 1).Value = "No pending matches to review."
        Exit Sub
    End If

    Dim m As Dictionary
    Dim rec As Dictionary
    Dim r As Long
    r = 2

    For Each m In queue
        Dim records As Collection
        Set records = m("records")

        For Each rec In records
            ws.Cells(r, 1).Value = m("matchId")
            ws.Cells(r, 2).Value = m("proposedBy")
            ws.Cells(r, 3).Value = m("matchedAt")
            ws.Cells(r, 4).Value = m("amountVariance")
            ws.Cells(r, 5).Value = rec("side")
            ws.Cells(r, 6).Value = rec("reference")
            ws.Cells(r, 7).Value = rec("amount")
            ws.Cells(r, 8).Value = rec("currency")
            r = r + 1
        Next rec
    Next m

    ws.Columns("A:H").AutoFit
End Sub
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

Public Function GetOpenBreaks() As Collection
    Dim responseText As String
    responseText = mHttpClient.GetJson("/recon/open-breaks", mAuth.CurrentToken)

    Dim response As Collection
    Set response = JsonConverter.ParseJson(responseText)

    Set GetOpenBreaks = response
End Function

Public Function GetMatchingQueue() As Collection
    Dim responseText As String
    responseText = mHttpClient.GetJson("/recon/matching-queue", mAuth.CurrentToken)

    Dim response As Collection
    Set response = JsonConverter.ParseJson(responseText)

    Set GetMatchingQueue = response
End Function

Public Function ProposeMatch(ByVal recordIds As Collection) As Boolean
    Dim requestBody As Object
    Set requestBody = CreateObject("Scripting.Dictionary")
    requestBody.Add "recordIds", recordIds

    Dim jsonBody As String
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    Dim responseText As String
    responseText = mHttpClient.PostJson("/recon/propose-match", jsonBody, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    ProposeMatch = response.Exists("id")
End Function

Public Function ApproveMatch(ByVal matchId As Long) As Boolean
    Dim responseText As String
    responseText = mHttpClient.PostJson("/recon/approve-match/" & matchId, "{}", mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    ApproveMatch = response.Exists("status")
End Function

Public Function RejectMatch(ByVal matchId As Long) As Boolean
    Dim responseText As String
    responseText = mHttpClient.PostJson("/recon/reject-match/" & matchId, "{}", mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    RejectMatch = response.Exists("status")
End Function

Public Sub RemoveReconciliationSheetsIfExists()
    If ThisWorkbook.Sheets.Count <= 1 Then Exit Sub

    Dim ws As Worksheet

    Set ws = Nothing
    On Error Resume Next
    Set ws = ThisWorkbook.Sheets("Open Breaks")
    On Error GoTo 0
    If Not ws Is Nothing And ThisWorkbook.Sheets.Count > 1 Then
        Application.DisplayAlerts = False
        ws.Delete
        Application.DisplayAlerts = True
    End If

    Set ws = Nothing
    On Error Resume Next
    Set ws = ThisWorkbook.Sheets("Matching Queue")
    On Error GoTo 0
    If Not ws Is Nothing And ThisWorkbook.Sheets.Count > 1 Then
        Application.DisplayAlerts = False
        ws.Delete
        Application.DisplayAlerts = True
    End If
End Sub
