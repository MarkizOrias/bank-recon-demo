VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmChangePassword 
   Caption         =   "Change Password"
   ClientHeight    =   390
   ClientLeft      =   -70
   ClientTop       =   -300
   ClientWidth     =   600
   OleObjectBlob   =   "frmChangePassword.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmChangePassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public IsForced As Boolean

Public Sub ShowForm(ByVal forced As Boolean)
    IsForced = forced
    ApplyLayout
    Me.Show vbModal
End Sub

Private Sub UserForm_Initialize()
    ApplyLayout
End Sub

Private Sub ApplyLayout()
    Dim rowOffset As Long
    rowOffset = 0

    If IsForced Then
        Me.lblCurrentPassword.visible = False
        Me.txtCurrentPassword.visible = False
        rowOffset = 32
    Else
        Me.lblCurrentPassword.visible = True
        Me.txtCurrentPassword.visible = True
    End If

    With Me
        .Caption = IIf(IsForced, "Set Your Password", "Change Password")
        .Width = 260
        .Height = IIf(IsForced, 175, 205)
        .StartUpPosition = 1
        .BackColor = RGB(240, 240, 240)
    End With

    If Not IsForced Then
        With Me.lblCurrentPassword
            .Caption = "Current Password"
            .Left = 20
            .Top = 20
            .Height = 18
            .Font.Name = "Segoe UI"
            .Font.Size = 9
            .BackStyle = fmBackStyleTransparent
            .WordWrap = False
            .AutoSize = True
        End With

        With Me.txtCurrentPassword
            .Left = 95
            .Top = 18
            .Width = 135
            .Height = 20
            .Font.Name = "Segoe UI"
            .Font.Size = 9
            .PasswordChar = "*"
            .TabIndex = 0
        End With
    End If

    With Me.lblNewPassword
        .Caption = "New Password"
        .Left = 20
        .Top = 52 - rowOffset
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
        .WordWrap = False
        .AutoSize = True
    End With

    With Me.txtNewPassword
        .Left = 95
        .Top = 50 - rowOffset
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .PasswordChar = "*"
        .TabIndex = 1
    End With

    With Me.lblConfirmPassword
        .Caption = "Confirm Password"
        .Left = 20
        .Top = 84 - rowOffset
        .Height = 18
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
        .WordWrap = False
        .AutoSize = True
    End With

    With Me.txtConfirmPassword
        .Left = 95
        .Top = 82 - rowOffset
        .Width = 135
        .Height = 20
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .PasswordChar = "*"
        .TabIndex = 2
    End With

    With Me.cmdSave
        .Caption = "Save"
        .Left = 95
        .Top = 122 - rowOffset
        .Width = 65
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Default = True
        .TabIndex = 3
    End With

    If IsForced Then
        Me.txtNewPassword.SetFocus
    Else
        Me.txtCurrentPassword.SetFocus
    End If
End Sub

Private Sub cmdSave_Click()
    If Me.txtNewPassword.Value <> Me.txtConfirmPassword.Value Then
        MsgBox "New password and confirmation don't match."
        Exit Sub
    End If

    If Len(Me.txtNewPassword.Value) < 8 Then
        MsgBox "New password must be at least 8 characters."
        Exit Sub
    End If

    Dim currentPwd As String
    
    'If temp Pass to New pass, hide current pwd query
    If IsForced Then
        currentPwd = mAuth.ConsumeLastPassword()
    Else
        currentPwd = Me.txtCurrentPassword.Value
    End If

    If mAuth.ChangePassword(currentPwd, Me.txtNewPassword.Value) Then
        MsgBox "Password changed successfully."
        Me.Hide
    Else
        MsgBox "Current password is incorrect."
    End If
End Sub
