Attribute VB_Name = "mDevTools"
Option Explicit

Public Const EXPORT_PATH As String = "C:\Users\Georgi\VBA\src\"

Public Sub ExportAllModules()

    Dim comp As VBIDE.VBComponent
    Dim ext As String
    
    For Each comp In ThisWorkbook.VBProject.VBComponents
        
        Select Case comp.Type
            Case vbext_ct_StdModule
                ext = ".bas" '-> basic module
            Case vbext_ct_ClassModule
                ext = ".cls" '-> class module
            Case vbext_ct_MSForm
                ext = ".frm" '-> MSforms
            Case vbext_ct_Document
                ext = "" '-> skip workbooks
        End Select
        
        If ext <> "" Then
            comp.Export EXPORT_PATH & comp.Name & ext
        End If
    Next comp

End Sub

