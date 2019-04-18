Sub MultipleYearStockData():
    
'Loop through ALL Worksheets 2014, 2015, and 2016
    For Each ws In Worksheets
    
'Find the last row of each year in worksheets
'Put ws. in front of Cells to iterate through all Worksheets
lastrowyear = ws.Cells(Rows.Count, "A").End(xlUp).Row + 1

'Grab the total amount of volume each stock had over the year
'Set Variables
    Dim i As Long
    Dim lastrow As Long
    Dim summary_table As Long
    'Dynamic variable
    summary_table = 2
     
    'Set variable for ticker name
    Dim ticker_name As String
     
    'Set variable for total amount of volume each stock had over the year
    Dim total_stock_volume As LongLong
    total_stock_volume = 0
        
    'Determine last row
    lastrow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    
    'Create two columns titled "Ticker" and "Total Stock Volume"
    'Set values in column 9 (Ticker) and format: bold, autofit
        ws.Cells(1, 9).Value = "Ticker"
        ws.Cells(1, 9).Font.Bold = True
        ws.Range("I:J").EntireColumn.AutoFit
        
    'Set values in column 10 (Total Stock Volume) and format: bold, autofit
        ws.Cells(1, 10).Value = "Total Stock Volume"
        ws.Cells(1, 10).Font.Bold = True
        ws.Range("I:J").EntireColumn.AutoFit
   
    'Loop through each year of stock data
  
        For i = 2 To lastrow
                    
            'Check if we are still within the same ticker name
            If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
                    
                    'Set the ticker name
                    ticker_name = ws.Cells(i, 1).Value
                    ws.Cells(summary_table, 9).Value = ticker_name
                    
                    'Add to the total stock volume
                    total_stock_volume = total_stock_volume + ws.Cells(i, 7).Value
                    ws.Cells(summary_table, 10).Value = total_stock_volume
                        
                    'Add one to summary table row
                    summary_table = summary_table + 1
                    
                    'Reset the volume total
                    total_stock_volume = 0
                
                Else
                    total_stock_volume = total_stock_volume + ws.Cells(i, 7).Value
                        
            End If

        Next i

    Next ws

End Sub



