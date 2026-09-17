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

Public Sub ImportAllModules()

    Dim fileName As String
    Dim compName As String
    Dim fileExt As String
    Dim comp As VBIDE.VBComponent
    
    fileName = Dir(EXPORT_PATH & "*.*")
    Do While fileName <> ""
        fileExt = LCase(Right(fileName, 4))
        If fileExt = ".bas" Or fileExt = ".cls" Or fileExt = ".frm" Then
            compName = Left(fileName, Len(fileName) - 4)

            If compName <> "mDevTools" Then
                On Error Resume Next
                Set comp = ThisWorkbook.VBProject.VBComponents(compName)
                On Error GoTo 0

                If Not comp Is Nothing Then
                    ThisWorkbook.VBProject.VBComponents.Remove comp
                    Set comp = Nothing
                End If

                ThisWorkbook.VBProject.VBComponents.Import EXPORT_PATH & fileName
            End If
        End If

        fileName = Dir
    Loop

End Sub
