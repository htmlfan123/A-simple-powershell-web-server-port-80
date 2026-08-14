param(
    [int]$Port = 8080
)

# Initialize the http listner
$listener = New-Object System.Net.HttpListener

# FIX: fixed so doesent require admin
$listener.Prefixes.Add("http://localhost:$Port/")

try {
    $listener.Start()
    Write-Host "Server running on http://localhost:$Port/"
    Write-Host "Press Ctrl+C in this console to stop the server."

    while ($true) {
        try {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            $path = $request.Url.AbsolutePath

            # Plain response with correct PowerShell newlines (`n)
            $body = "PowerShell server `n$path `nMethod: $($request.HttpMethod) `nTime: $(Get-Date)"

            $data = [System.Text.Encoding]::UTF8.GetBytes($body)

            $response.StatusCode = 200
            $response.ContentType = "text/plain; charset=utf-8"
            $response.ContentLength64 = $data.Length
            $response.OutputStream.Write($data, 0, $data.Length)
            $response.OutputStream.Close()
        }
        catch {
            
            Write-Warning "Error processing request: $($_.Exception.Message)"
        }
    }
}
catch {
    Write-Error "Failed to start server: $($_.Exception.Message)"
}
finally {
    
    if ($null -ne $listener -and $listener.IsListening) {
        $listener.Stop()
        $listener.Close()
        Write-Host "Server stopped."
    }
}
