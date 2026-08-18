# Simple PowerShell Web Server (port 8080)

A minimal, single-file PowerShell web server for quick local testing on port 8080.

- Quick access: http://localhost:8080

## Prerequisites

- PowerShell 5.1+ (Windows) or PowerShell 7+ (cross-platform).
- If you bind to ports below 1024 (for example port 80) or if you receive permission errors, run PowerShell as Administrator or register an HTTP URL ACL entry.

## Quick start

1. Copy the script below into a file named `Simple-Web-Server.ps1` (or paste it into a PowerShell session).
2. Run it from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\Simple-Web-Server.ps1
```

3. Open a browser and visit: http://localhost:8080

## Example script

```powershell
# Simple-Web-Server.ps1
$prefix = 'http://+:8080/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)

try {
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
}
finally {
    if ($listener -and $listener.IsListening) {
        $listener.Stop()
        $listener.Close()
    }
}
```

## Configuration

- To bind to a single interface instead of all interfaces, replace `http://+:8080/` with an explicit address such as `http://127.0.0.1:8080/`.
- To use a different port, update the `:8080` portion of the prefix.

## Security

- This server is intended for local development and testing only. It is not hardened for production use.
- Do not expose this server to the public internet unless you understand and mitigate the security risks.
- When binding to privileged ports (< 1024) or to addresses other than `localhost`, ensure you have appropriate OS-level permissions and firewall rules in place.

## Troubleshooting

- "Access denied" or permission errors: run PowerShell as Administrator or register a URL ACL with `netsh http add urlacl url=http://+:8080/ user=DOMAIN\\User`.
- Port already in use: stop the other process or change the port in the `$prefix` variable.
- If you see encoding issues in the browser, confirm the response `ContentType` and the HTML `meta charset` both specify UTF-8.

## Contributing

Contributions and improvements are welcome. If you'd like me to add the script file `Simple-Web-Server.ps1` to the repository, a LICENSE, or a CONTRIBUTING guide, tell me which license you prefer and I will add them.

## License

This repository does not include a license by default. If you want an explicit license (for example, MIT), say which one and I will add a LICENSE file.
