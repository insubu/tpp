Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:8080/webhook/")
$listener.Start()
Write-Host "Webhook listener running on port 8080..."

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $body = New-Object System.IO.StreamReader($request.InputStream).ReadToEnd()

    # 打印或处理传入数据
    Write-Host "Received webhook: $body"

    # 运行你的流程，如执行脚本
    Start-Process -FilePath "C:\scripts\your-script.ps1"

    $response = $context.Response
    $response.StatusCode = 200
    $response.OutputStream.Close()
}
