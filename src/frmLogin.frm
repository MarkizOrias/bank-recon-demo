VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmLogin 
   Caption         =   "Recon Tool - Login"
   ClientHeight    =   640
   ClientLeft      =   -150
   ClientTop       =   -750
   ClientWidth     =   520
   OleObjectBlob   =   "frmLogin.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'Redesigned formatting
Private Sub UserForm_Initialize()

    ' Form
    With Me
        .Caption = "Login"
        .Width = 260
        .Height = 175
        .StartUpPosition = 1
        .BackColor = RGB(240, 240, 240)
    End With

    ' Username label
    With Me.lblUsername
        .Caption = "Username"
        .Left = 20
        .Top = 20
        .Width = 70
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
    End With

    ' Username textbox
    With Me.txtUsername
        .Left = 95
        .Top = 18
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .TabIndex = 0
    End With

    ' Password label
    With Me.lblPassword
        .Caption = "Password"
        .Left = 20
        .Top = 52
        .Width = 70
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
    End With

    ' Password textbox
    With Me.txtPassword
        .Left = 95
        .Top = 50
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .PasswordChar = "*"
        .TabIndex = 1
    End With

    ' Login button
    With Me.cmdLogin
        .Caption = "Login"
        .Left = 95
        .Top = 90
        .Width = 65
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Default = True
        .TabIndex = 2
    End With

    ' Cancel button
    With Me.cmdCancel
        .Caption = "Cancel"
        .Left = 165
        .Top = 90
        .Width = 65
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Cancel = True
        .TabIndex = 3
    End With

    ' Initial focus
    Me.txtUsername.SetFocus

End Sub

'Close workbook on cancel
Private Sub cmdCancel_Click()

    ThisWorkbook.Saved = True
    Application.Quit
End Sub

'Login functionality
Private Sub cmdLogin_Click()

    Dim attemptedUsername As String
    Dim attemptedPassword As String

    'User's input values assignment
    attemptedUsername = Me.txtUsername.Value
    attemptedPassword = Me.txtPassword.Value

    'Error message when either field left empty
    If attemptedUsername = "" Or attemptedPassword = "" Then
        MsgBox "Please enter both username and password."
        Exit Sub
    End If

    'Hide the form and continue operating
    If mAuth.Login(attemptedUsername, attemptedPassword) Then
        Me.Hide
    Else
    
    'Error message on pwd mismatch
        MsgBox "Invalid username or password."
        Me.txtPassword.Value = ""
    End If
    
End Sub

Private Sub UserForm_Click()

End Sub
