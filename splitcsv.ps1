$folderPath = "C:\YourFolderPath"
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false  # Run Excel in background

# Get all .xlsx files in the folder
$files = Get-ChildItem -Path $folderPath -Filter *.xlsx

foreach ($file in $files) {
    $workbook = $excel.Workbooks.Open($file.FullName)

    foreach ($sheet in $workbook.Sheets) {
        $cells = $sheet.Cells.Find("ab")

        if ($cells -ne $null) {
            Write-Output "Found in: $($file.Name) - Sheet: $($sheet.Name) - Cell: $($cells.Address)"
        }
    }

    $workbook.Close($false)  # Close without saving
}

$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)

###################################
$folderPath = "C:\YourFolderPath"
$outputFile = "$folderPath\SearchResults.xlsx"

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$resultsWorkbook = $excel.Workbooks.Add()
$resultsSheet = $resultsWorkbook.Sheets(1)

# Set header row
$resultsSheet.Cells(1,1).Value2 = "File Name"
$resultsSheet.Cells(1,2).Value2 = "Sheet Name"
$resultsSheet.Cells(1,3).Value2 = "Cell Address"
$resultsSheet.Cells(1,4).Value2 = "Hyperlink"
$row = 2

# Get all .xlsx files in the folder
$files = Get-ChildItem -Path $folderPath -Filter *.xlsx

foreach ($file in $files) {
    $workbook = $excel.Workbooks.Open($file.FullName)

    foreach ($sheet in $workbook.Sheets) {
        $cells = $sheet.Cells.Find("ab")
        
        if ($cells -ne $null) {
            $cellAddress = $cells.Address
            $resultsSheet.Cells($row,1).Value2 = $file.Name
            $resultsSheet.Cells($row,2).Value2 = $sheet.Name
            $resultsSheet.Cells($row,3).Value2 = $cellAddress

            # Create hyperlink to the original file
            $hyperlinkPath = $file.FullName
            $resultsSheet.Hyperlinks.Add($resultsSheet.Cells($row,4), $hyperlinkPath, "", "", "Open File")

            $row++
        }
    }

    $workbook.Close($false)
}

# Save results
$resultsWorkbook.SaveAs($outputFile)
$resultsWorkbook.Close()
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)

Write-Output "Results saved to: $outputFile"
