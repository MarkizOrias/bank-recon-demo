Attribute VB_Name = "mTest"
Sub TestGetOpenBreaks()
    Dim breaks As Collection
    Set breaks = mReconciler.GetOpenBreaks()
    MsgBox "Open breaks count: " & breaks.Count
End Sub
