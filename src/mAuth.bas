Attribute VB_Name = "mAuth"
Option Explicit

'VBA Session applicable variables - no local storage
Public CurrentToken As String
Public CurrentRole As String
Public CurrentUsername As String

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
        Login = True
    Else
        Login = False
    End If
End Function



