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

$response.StatusDescription = "Webhook received"

# 设置响应类型（如纯文本或 JSON）
$response.ContentType = "text/plain"

# 写入响应体（可改为输出 JSON 或 HTML）
$buffer = [System.Text.Encoding]::UTF8.GetBytes("Thanks! Message received.")
$response.OutputStream.Write($buffer, 0, $buffer.Length)
    
    $response.OutputStream.Close()
}
##################################################################
function Dispatch-Job {
    param($cmd, $payload)

    switch ($cmd) {

        "backup" {
            Start-Job -Name "BackupJob" -ScriptBlock {
                param($data)
                # 模拟备份逻辑
                Start-Sleep -Seconds 3
                "Backup completed for $($data.target)"
            } -ArgumentList $payload
        }

        "notify" {
            Start-Job -Name "NotifyJob" -ScriptBlock {
                param($data)
                # 模拟通知逻辑
                "Notification sent to $($data.email)"
            } -ArgumentList $payload
        }

        default {
            Write-Warning "Unknown command: $cmd"
        }
    }
}

# 模拟 webhook 请求
$cmd = "greet"
$payload = @{ name = "怡然" }

Dispatch-Job -cmd $cmd -payload $payload
