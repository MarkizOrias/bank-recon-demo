Attribute VB_Name = "mAuthTest"
'Short test - paste your admin pwd in the argument placeholder <YOUR PWD>
Sub TestLogin()
    If mAuth.Login("admin", "<YOUR PWD>") Then
        MsgBox "Logged in! Role: " & mAuth.CurrentRole
    Else
        MsgBox "Login failed."
    End If
End Sub
