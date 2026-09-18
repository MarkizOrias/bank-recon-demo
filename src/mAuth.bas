Attribute VB_Name = "mAuth"
Option Explicit

'VBA Session applicable variables - no local storage
Public CurrentToken As String
Public CurrentRole As String
Public CurrentUsername As String
Public CurrentMustChangePassword As Boolean
Private pLastPassword As String

'Login function with username & pwd input arguments, bool as output
Public Function Login(ByVal username As String, ByVal password As String) As Boolean

    
    Dim requestBody As Object
    
    'Microsoft Scripting Runtime library dictionary enabled
    Set requestBody = CreateObject("Scripting.Dictionary")
    
    requestBody.Add "username", username
    requestBody.Add "password", password

    Dim jsonBody As String
    
    'Converting username & pwd to JSON format
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    Dim responseText As String
    
    'Calling PostJson with /login endpoint and jsonBody with username & pwd
    responseText = mHttpClient.PostJson("/login", jsonBody)

    Dim response As Object
    
    'Parsing username & pwd from JSON format
    Set response = JsonConverter.ParseJson(responseText)

    If response.Exists("token") Then
        CurrentToken = response("token")
        CurrentRole = response("role")
        CurrentUsername = username
        CurrentMustChangePassword = response("mustChangePassword")
        pLastPassword = password
        Login = True
    Else
        Login = False
    End If
End Function

'Hide current pwd prompt from temp to new pwd logic
Public Function ConsumeLastPassword() As String
    ConsumeLastPassword = pLastPassword
    pLastPassword = ""
End Function

'Change pwd logic - current and new pwd as input, bool as output, calling /users/me/password endpoint
Public Function ChangePassword(ByVal currentPassword As String, ByVal newPassword As String) As Boolean
    Dim requestBody As Object
    Set requestBody = CreateObject("Scripting.Dictionary")
    requestBody.Add "currentPassword", currentPassword
    requestBody.Add "newPassword", newPassword

    Dim jsonBody As String
    jsonBody = JsonConverter.ConvertToJson(requestBody)

    Dim responseText As String
    responseText = mHttpClient.PatchJson("/users/me/password", jsonBody, mAuth.CurrentToken)

    Dim response As Dictionary
    Set response = JsonConverter.ParseJson(responseText)

    If response.Exists("success") Then
        CurrentMustChangePassword = False
        ChangePassword = True
    Else
        ChangePassword = False
    End If
End Function
