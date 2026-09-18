Attribute VB_Name = "mAdminPanel"
Option Explicit
'Setup Admin Panel at start
Public Sub SetupAdminPanelSheet()
    Dim ws As Worksheet
    Dim found As Boolean
    found = False

    'Loop through all existing sheets, if Admin Panel is found, stop searching.
    For Each ws In ThisWorkbook.Sheets
        If ws.Name = "Admin Panel" Then
            found = True
            Exit For
        End If
    Next ws

    'If not found, rename the first sheet existing to Admin Panel
    If Not found Then
        Set ws = ThisWorkbook.Sheets.Add(Before:=ThisWorkbook.Sheets(1))
        ws.Name = "Admin Panel"
    End If

    Set ws = ThisWorkbook.Sheets("Admin Panel")

    'Fill datagrid headers
    ThisWorkbook.Sheets("Admin Panel").Activate

    'Call datagrid filler
    mRibbon.RefreshAdminUsersSheet
    
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

'User's creation function, input arg stored in VBA variables, not locally, from the AddUser form. Output is bool.
Public Function CreateUser(ByVal username As String, ByVal role As String, ByRef tempPassword As String) As Boolean
    Dim requestBody As Object
    Set requestBody = CreateObject("Scripting.Dictionary")
    requestBody.Add "username", username
    requestBody.Add "role", role

    Dim jsonBody As String
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    'POST call to /admin/users endpoint
    Dim responseText As String
    responseText = mHttpClient.PostJson("/admin/users", jsonBody, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    'Temporary Password response
    If response.Exists("tempPassword") Then
        tempPassword = response("tempPassword")
        CreateUser = True
    Else
        CreateUser = False
    End If
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
Public Function ReactivateUser(ByVal userId As Long, ByRef tempPassword As String) As Boolean
    Dim responseText As String
    responseText = mHttpClient.PatchJson("/admin/users/" & userId & "/reactivate", "{}", mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    If response.Exists("tempPassword") Then
        tempPassword = response("tempPassword")
        ReactivateUser = True
    Else
        ReactivateUser = False
    End If
End Function

'Remove Admin Panel on close
Public Sub RemoveAdminPanelSheetIfExists()
    On Error Resume Next
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Admin Panel")
    If Not ws Is Nothing Then
        Application.DisplayAlerts = False
        ws.Delete
        Application.DisplayAlerts = True
    End If
    On Error GoTo 0
End Sub
