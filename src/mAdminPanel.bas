Attribute VB_Name = "mAdminPanel"
Option Explicit
'Setup Admin Panel at start
Public Sub SetupAdminPanelSheet()
    Dim ws As Worksheet
    Dim found As Boolean
    found = False

    For Each ws In ThisWorkbook.Sheets
        If ws.Name = "Admin Panel" Then
            found = True
            Exit For
        End If
    Next ws

    If Not found Then
        Set ws = ThisWorkbook.Sheets.Add(Before:=ThisWorkbook.Sheets(1))
        ws.Name = "Admin Panel"
    End If

    Set ws = ThisWorkbook.Sheets("Admin Panel")

    If ws.Cells(1, 1).Value = "" Then
        ws.Cells(1, 1).Value = "ID"
        ws.Cells(1, 2).Value = "Username"
        ws.Cells(1, 3).Value = "Role"
        ws.Cells(1, 4).Value = "Active"
        ws.Cells(1, 5).Value = "Created At"
        ws.Range("A1:E1").Font.Bold = True
    End If

    ws.Activate

    RefreshAdminUsersSheet
End Sub

'Users endpoint query function - collection output
Public Function GetUsers() As Collection

    Dim responseText As String
    
    'Read endpoint's output and current session's token
    responseText = mHttpClient.GetJson("/admin/users", mAuth.CurrentToken)

    Dim response As Collection
    'Parsing JSON output to a Collection of users
    Set response = JsonConverter.ParseJson(responseText)

    Set GetUsers = response
    
End Function

'User's creation function, input arg stored in VBA variables, not locally. Output is bool.
Public Function CreateUser(ByVal username As String, ByVal password As String, ByVal role As String) As Boolean
    Dim requestBody As Object
    Set requestBody = CreateObject("Scripting.Dictionary")
    requestBody.Add "username", username
    requestBody.Add "password", password
    requestBody.Add "role", role

    Dim jsonBody As String
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    Dim responseText As String
    responseText = mHttpClient.PostJson("/admin/users", jsonBody, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    CreateUser = response.Exists("id")
End Function

'User's deactivation function, userId as input arg. Output is bool.
Public Function DeactivateUser(ByVal userId As Long) As Boolean
    Dim responseText As String
    responseText = mHttpClient.DeleteJson("/admin/users/" & userId, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    DeactivateUser = response.Exists("active")
End Function

'User's reactivation function, userId as input arg. Output is bool.
Public Function ReactivateUser(ByVal userId As Long, ByVal newPassword As String) As Boolean
    Dim requestBody As Object
    Set requestBody = CreateObject("Scripting.Dictionary")
    requestBody.Add "password", newPassword

    Dim jsonBody As String
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    Dim responseText As String
    responseText = mHttpClient.PatchJson("/admin/users/" & userId & "/reactivate", jsonBody, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    ReactivateUser = response.Exists("active")
End Function
