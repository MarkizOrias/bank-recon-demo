VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmTempPassword 
   Caption         =   "Temporary Password"
   ClientHeight    =   2020
   ClientLeft      =   80
   ClientTop       =   300
   ClientWidth     =   3050
   OleObjectBlob   =   "frmTempPassword.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmTempPassword"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mClipboardObj As New DataObject

Public Sub Display(ByVal infoText As String, ByVal valueText As String)
    Me.lblInfo.Caption = infoText
    Me.txtValue.Value = valueText
    Me.txtValue.SetFocus
    Me.txtValue.SelStart = 0
    Me.txtValue.SelLength = Len(valueText)
End Sub

Private Sub UserForm_Initialize()
    With Me
        .Caption = "Temporary Password"
        .Width = 280
        .Height = 175
        .StartUpPosition = 1
        .BackColor = RGB(240, 240, 240)
    End With

    With Me.lblInfo
        .Left = 20
        .Top = 15
        .Width = 240
        .Height = 40
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .BackStyle = fmBackStyleTransparent
        .WordWrap = True
    End With

    With Me.txtValue
        .Left = 20
        .Top = 60
        .Width = 240
        .Height = 22
        .Font.Name = "Segoe UI"
        .Font.Size = 11
        .Locked = True
        .TabIndex = 0
    End With

    With Me.cmdCopy
        .Caption = "Copy"
        .Left = 20
        .Top = 100
        .Width = 100
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .TabIndex = 1
    End With

    With Me.cmdOK
        .Caption = "OK"
        .Left = 160
        .Top = 100
        .Width = 100
        .Height = 24
        .Font.Name = "Segoe UI"
        .Font.Size = 9
        .Default = True
        .TabIndex = 2
    End With
End Sub

Private Sub cmdCopy_Click()
    mClipboardObj.SetText Me.txtValue.Value
    mClipboardObj.PutInClipboard
    MsgBox "Copied to clipboard."
End Sub

Private Sub cmdOK_Click()
    Me.Hide
End Sub
