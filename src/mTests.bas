Attribute VB_Name = "mTests"
'Short test - paste your admin pwd in the argument placeholder <YOUR PWD>
Sub TestLogin()
    If mAuth.Login("admin", "<YOUR PWD>") Then
        MsgBox "Logged in! Role: " & mAuth.CurrentRole
    Else
        MsgBox "Login failed."
    End If
End Sub
'Short test - Query user's collection
Sub TestGetUsers()
    If mAuth.CurrentToken = "" Then
        MsgBox "Not logged in — run TestLogin first."
        Exit Sub
    End If

    Dim users As Collection
    Set users = mAdminPanel.GetUsers()

    Dim u As Dictionary
    Dim output As String
    For Each u In users
        output = output & u("username") & " (" & u("role") & ") - active: " & u("active") & vbNewLine
    Next u

    MsgBox output
End Sub
'Short test - Create new user
Sub TestAdminFunctions()
    Dim created As Boolean
    created = mAdminPanel.CreateUser("testuser2", "TestPass789!", "reconciler")
    MsgBox "Created: " & created
End Sub
