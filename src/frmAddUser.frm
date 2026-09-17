VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmAddUser 
   Caption         =   "Add User"
   ClientHeight    =   1480
   ClientLeft      =   10
   ClientTop       =   0
   ClientWidth     =   1780
   OleObjectBlob   =   "frmAddUser.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmAddUser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub UserForm_Initialize()

    ' Form
    With Me
        .Caption = "Add New User"
        .Width = 260
        .Height = 210
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

    ' Role label
    With Me.lblRole
        .Caption = "Role"
        .Left = 20
        .Top = 84
        .Width = 70
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
    End With

    ' Role combobox
    With Me.cboRole
        .Left = 95
        .Top = 82
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Style = fmStyleDropDownList
        .TabIndex = 2
        .AddItem "admin"
        .AddItem "reconciler"
        .ListIndex = 1
    End With

    ' Save button
    With Me.cmdSave
        .Caption = "Save"
        .Left = 95
        .Top = 124
        .Width = 65
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Default = True
        .TabIndex = 3
    End With

    ' Cancel button
    With Me.cmdCancel
        .Caption = "Cancel"
        .Left = 165
        .Top = 124
        .Width = 65
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Cancel = True
        .TabIndex = 4
    End With

    ' Initial focus
    Me.txtUsername.SetFocus
    
    Me.StartUpPosition = 1 ' CenterOwner

    With Me.cboRole
        .AddItem "admin"
        .AddItem "reconciler"
        .ListIndex = 1 ' defaults to "reconciler" — the more common case
    End With

    With Me.txtPassword
        .PasswordChar = "*"
    End With

    Me.cmdSave.Default = True
    Me.cmdCancel.Cancel = True

End Sub

'Save button
Private Sub cmdSave_Click()
    Dim newUsername As String
    Dim newPassword As String
    Dim newRole As String

    newUsername = Me.txtUsername.Value
    newPassword = Me.txtPassword.Value
    newRole = Me.cboRole.Value

    If newUsername = "" Or newPassword = "" Or newRole = "" Then
        MsgBox "Please fill in all fields."
        Exit Sub
    End If

    If mAdminPanel.CreateUser(newUsername, newPassword, newRole) Then
        Me.Hide
        mRibbon.RefreshAdminUsersSheet
    Else
        MsgBox "Failed to create user — username may already exist."
    End If
End Sub

'Cancel button
Private Sub cmdCancel_Click()
    Me.Hide
End Sub
