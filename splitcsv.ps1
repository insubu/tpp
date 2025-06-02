$inputFile = "large.csv"
$linesPerFile = 10000
$header = Get-Content $inputFile -First 1
$lines = Get-Content $inputFile | Select-Object -Skip 1
$i = 1
for ($j = 0; $j -lt $lines.Count; $j += $linesPerFile) {
    $outputFile = "split_$i.csv"
    Set-Content $outputFile -Value $header
    Add-Content $outputFile -Value ($lines[$j..[Math]::Min($j + $linesPerFile - 1, $lines.Count - 1)])
    $i++
}
