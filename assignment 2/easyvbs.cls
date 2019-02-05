VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit

Sub StockAnalysis()

    Dim ws As Worksheet
    Dim Ticker As String
    Dim Total_Stock_Volume As Double
    Dim Summary_Table_Row As Integer
    Dim LastRow As Long
    Dim i As Long

    For Each ws In Worksheets
    ws.Activate

    Total_Stock_Volume = 0
    Summary_Table_Row = 2

    Range("I1").Value = "Ticker"
    Range("J1").Value = "Total Stock Volume "

 
    LastRow = Cells(Rows.Count, 1).End(xlUp).Row
    
   

    For i = 2 To LastRow
        If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then


            Ticker = Cells(i, 1).Value

            Total_Stock_Volume = Total_Stock_Volume + Cells(i, 7).Value

            Range("I" & Summary_Table_Row).Value = Ticker

            Range("J" & Summary_Table_Row).Value = Total_Stock_Volume

            Summary_Table_Row = Summary_Table_Row + 1

            Total_Stock_Volume = 0


        Else


            Total_Stock_Volume = Total_Stock_Volume + Cells(i, 7).Value


        End If

    Next i

Next ws


End Sub


