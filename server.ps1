$Hso = New-Object Net.HttpListener
$Hso.Prefixes.Add("http://localhost:8000/")
$Hso.Start()
Write-Host "Server started at http://localhost:8000/"
Write-Host "Press Ctrl+C to stop the server"

while ($Hso.IsListening) {
    $HC = $Hso.GetContext()
    $HRes = $HC.Response
    $path = $HC.Request.RawUrl
    if ($path -eq "/") { $path = "/rankings.html" }
    $path = Join-Path $PSScriptRoot $path.TrimStart("/")
    
    if (Test-Path $path -PathType Leaf) {
        $content = Get-Content $path -Raw
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $HRes.ContentLength64 = $buffer.Length
        $HRes.OutputStream.Write($buffer, 0, $buffer.Length)
    } else {
        $HRes.StatusCode = 404
    }
    
    $HRes.Close()
} 