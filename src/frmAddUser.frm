VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmAddUser 
   Caption         =   "Add User"
   ClientHeight    =   280
   ClientLeft      =   -140
   ClientTop       =   -600
   ClientWidth     =   340
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
        .Height = 175
        .StartUpPosition = 1
        .BackColor = RGB(240, 240, 240)
    End With

    ' Username label
    With Me.lblUsername
        .Caption = "Username"
        .Left = 20
        .Top = 20
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
        .AutoSize = True
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

    ' Role label
    With Me.lblRole
        .Caption = "Role"
        .Left = 20
        .Top = 52
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
        .AutoSize = True
    End With

    ' Role combobox
    With Me.cboRole
        .Left = 95
        .Top = 50
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Style = fmStyleDropDownList
        .TabIndex = 1
        .AddItem "admin"
        .AddItem "reconciler"
        .ListIndex = 1
    End With

    ' Save button
    With Me.cmdSave
        .Caption = "Save"
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

'Save button
Private Sub cmdSave_Click()
    Dim newUsername As String
    Dim newRole As String
    Dim tempPassword As String

    newUsername = Me.txtUsername.Value
    newRole = Me.cboRole.Value

    If newUsername = "" Or newRole = "" Then
        MsgBox "Please fill in all fields."
        Exit Sub
    End If

    If mAdminPanel.CreateUser(newUsername, newRole, tempPassword) Then
        Me.Hide
        mRibbon.RefreshAdminUsersSheet
        frmTempPassword.Display "User '" & newUsername & "' created. Share this temporary password securely — it must be changed on first login:", tempPassword
        frmTempPassword.Show vbModal
    Else
        MsgBox "Failed to create user — username may already exist."
    End If
End Sub

'Cancel button
Private Sub cmdCancel_Click()
    Me.Hide
End Sub
