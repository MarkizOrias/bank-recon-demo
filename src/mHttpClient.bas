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
        PostJson = http.ResponseText

End Function
