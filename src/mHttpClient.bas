Attribute VB_Name = "mHttpClient"
Option Explicit

'Host server built in Cloudflare
Private Const BASE_URL As String = "https://recon-demo-worker.georgi-bargan.workers.dev"

'Declaring PostJson function with input arguments (authToken optional for first login call), Json response from Host as an output
Public Function PostJson(ByVal endpoint As String, ByVal jsonBody As String, Optional ByVal authToken As String = "") As String
    
    Dim http As Object
    
    'Windows built-in HTTP client object
    Set http = CreateObject("WinHttp.WinHttpRequest.5.1")
    
    'Synchronous POST call structure
    http.Open "POST", BASE_URL & endpoint, False
    
    'Tells worker to expect a JSON body
    http.SetRequestHeader "Content-Type", "application/json"
    
    'Assignment of authToken during first login attempt
    If authToken <> "" Then
        http.SetRequestHeader "Authorization", "Bearer " & authToken
    End If
    
    'Sends JSON to host
    http.Send jsonBody
    
    'Assigns response value to function's output
        PostJson = http.responseText

End Function

'Host endpoint JSON getter
Public Function GetJson(ByVal endpoint As String, Optional ByVal authToken As String = "") As String

    Dim http As Object

    Set http = CreateObject("WinHttp.WinHttpRequest.5.1")

    http.Open "GET", BASE_URL & endpoint, False

    If authToken <> "" Then
        http.SetRequestHeader "Authorization", "Bearer " & authToken
    End If

    http.Send

    GetJson = http.responseText
End Function

'Host endpoint JSON deletion
Public Function DeleteJson(ByVal endpoint As String, Optional ByVal authToken As String = "") As String
    Dim http As Object
    Set http = CreateObject("WinHttp.WinHttpRequest.5.1")

    http.Open "DELETE", BASE_URL & endpoint, False

    If authToken <> "" Then
        http.SetRequestHeader "Authorization", "Bearer " & authToken
    End If

    http.Send

    DeleteJson = http.responseText
End Function

'Host endpoint JSON patcher
Public Function PatchJson(ByVal endpoint As String, ByVal jsonBody As String, Optional ByVal authToken As String = "") As String
    Dim http As Object
    Set http = CreateObject("WinHttp.WinHttpRequest.5.1")

    http.Open "PATCH", BASE_URL & endpoint, False

    http.SetRequestHeader "Content-Type", "application/json"

    If authToken <> "" Then
        http.SetRequestHeader "Authorization", "Bearer " & authToken
    End If

    http.Send jsonBody

    PatchJson = http.responseText
End Function
