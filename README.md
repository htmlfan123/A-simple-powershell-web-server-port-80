# Simple PowerShell web server (port 8080)

A tiny, single-file PowerShell web server intended for quick local testing on port 8080.

- Quick access: http://localhost:8080

## Prerequisites

- PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform).
- If you bind to ports below 1024 (for example port 80) or if you receive permission errors, run PowerShell as Administrator or create an appropriate HTTP URL ACL entry.

## Usage

1. Copy the script below into a file named `Simple-Web-Server.ps1` (or paste it directly into a PowerShell session).
2. Run it from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\Simple-Web-Server.ps1
```

3. Open a browser and visit: http://localhost:8080

### Example script

```powershell
# Simple-Web-Server.ps1
$prefix = 'http://+:8080/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Listening on $prefix - press Ctrl+C to stop"

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $response = $context.Response

        $content = "<html><head><meta charset='utf-8'><title>Simple PowerShell Web Server</title></head><body><h1>Simple PowerShell Web Server</h1><p>Time: $(Get-Date)</p></body></html>"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)

        $response.ContentType = 'text/html; charset=utf-8'
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
    catch {
        Write-Warning "Listener error: $_"
    }
}
```

## Notes & Security

- This server is intended for local development and testing only. It is not hardened for production use.
- Do not expose this directly to the public internet unless you understand the security implications.
- If you need to bind to a specific IP instead of all interfaces, replace `http://+:8080/` with `http://127.0.0.1:8080/` or another explicit address.

## Troubleshooting

- "Access denied" or permission errors: run PowerShell as Administrator or register a URL ACL with `netsh http add urlacl url=http://+:8080/ user=DOMAIN\User`.
- If the port is already in use, stop the other process or change the port in the `$prefix` variable.

---

If you'd like, I can also:
- Add a short script file to the repository (Simple-Web-Server.ps1) with the example above.
- Add a LICENSE or CONTRIBUTING file.
