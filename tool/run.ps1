[CmdletBinding()]
param(
    [string]$Device = 'auto',
    [string]$ApiBaseUrl = '',
    [switch]$NoBackend,
    [switch]$SkipPubGet,
    [switch]$SetupOnly
)

$ErrorActionPreference = 'Stop'
$appRoot = Split-Path -Parent $PSScriptRoot
$workspaceRoot = Split-Path -Parent $appRoot
$backendRoot = Join-Path $workspaceRoot 'smartshrimp_be'
$localConfigPath = Join-Path $appRoot 'config\local.json'
$startedBackend = $null

function Test-TcpPort {
    param(
        [Parameter(Mandatory = $true)][string]$HostName,
        [Parameter(Mandatory = $true)][int]$Port
    )

    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $connectTask = $client.ConnectAsync($HostName, $Port)
        return $connectTask.Wait(750) -and $client.Connected
    }
    catch {
        return $false
    }
    finally {
        $client.Dispose()
    }
}

function Get-LocalConfig {
    if (-not (Test-Path -LiteralPath $localConfigPath)) {
        return $null
    }

    try {
        return Get-Content -LiteralPath $localConfigPath -Raw | ConvertFrom-Json
    }
    catch {
        throw "Invalid configuration: $localConfigPath. $($_.Exception.Message)"
    }
}

function Get-FlutterDevices {
    $rawDevices = (& flutter devices --machine | Out-String)
    if ($LASTEXITCODE -ne 0) {
        throw 'Unable to get the Flutter device list.'
    }

    try {
        return @($rawDevices | ConvertFrom-Json)
    }
    catch {
        throw "Flutter returned an invalid device list. Run 'flutter doctor -v'."
    }
}

function Select-FlutterDevice {
    param(
        [Parameter(Mandatory = $true)][object[]]$Devices,
        [Parameter(Mandatory = $true)][string]$RequestedDevice
    )

    $supported = @($Devices | Where-Object { $_.isSupported -ne $false })
    if ($supported.Count -eq 0) {
        throw "No Flutter device found. Run 'flutter devices' to diagnose."
    }

    if ($RequestedDevice -eq 'auto') {
        # Windows works out of the box on this repository and is the most stable
        # default. Android/web remain available through -Device.
        $selected = $supported | Where-Object { $_.id -eq 'windows' } | Select-Object -First 1
        if ($null -eq $selected) {
            $selected = $supported | Where-Object { $_.targetPlatform -like 'android*' } | Select-Object -First 1
        }
        if ($null -eq $selected) {
            $selected = $supported | Where-Object { $_.id -eq 'chrome' } | Select-Object -First 1
        }
        if ($null -eq $selected) {
            $selected = $supported | Select-Object -First 1
        }
        return $selected
    }

    if ($RequestedDevice -eq 'android') {
        $selected = $supported | Where-Object { $_.targetPlatform -like 'android*' } | Select-Object -First 1
    }
    else {
        $selected = $supported | Where-Object {
            $_.id -eq $RequestedDevice -or $_.name -eq $RequestedDevice
        } | Select-Object -First 1
    }

    if ($null -eq $selected) {
        $available = ($supported | ForEach-Object { "$($_.name) [$($_.id)]" }) -join ', '
        throw "Device '$RequestedDevice' was not found. Available: $available"
    }

    return $selected
}

if ($null -eq (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw "Flutter was not found in PATH. Install Flutter and run 'flutter doctor -v'."
}

Push-Location $appRoot
try {
    Write-Host '==> Checking Flutter devices...'
    $devices = Get-FlutterDevices
    $selectedDevice = Select-FlutterDevice -Devices $devices -RequestedDevice $Device
    Write-Host "==> Device: $($selectedDevice.name) [$($selectedDevice.id)]"

    $localConfig = Get-LocalConfig
    $apiWasExplicit = -not [string]::IsNullOrWhiteSpace($ApiBaseUrl)
    if (-not $apiWasExplicit -and $null -ne $localConfig -and
        $localConfig.PSObject.Properties.Name -contains 'API_BASE_URL' -and
        -not [string]::IsNullOrWhiteSpace([string]$localConfig.API_BASE_URL)) {
        $ApiBaseUrl = [string]$localConfig.API_BASE_URL
        $apiWasExplicit = $true
    }

    if ([string]::IsNullOrWhiteSpace($ApiBaseUrl)) {
        if ($selectedDevice.targetPlatform -like 'android*') {
            $isEmulator = $selectedDevice.emulator -eq $true
            if ($isEmulator) {
                $ApiBaseUrl = 'http://10.0.2.2:3000/api/v1'
            }
            else {
                throw 'A physical Android device needs -ApiBaseUrl with the backend host LAN IP.'
            }
        }
        else {
            $ApiBaseUrl = 'http://localhost:3000/api/v1'
        }
    }

    $ApiBaseUrl = $ApiBaseUrl.TrimEnd('/')
    $apiUri = $null
    if (-not [Uri]::TryCreate($ApiBaseUrl, [UriKind]::Absolute, [ref]$apiUri) -or
        $apiUri.Scheme -notin @('http', 'https')) {
        throw "API_BASE_URL must be an absolute http/https URL: $ApiBaseUrl"
    }

    if (-not $SkipPubGet) {
        Write-Host '==> Installing Flutter dependencies...'
        & flutter pub get
        if ($LASTEXITCODE -ne 0) {
            throw "'flutter pub get' failed with exit code $LASTEXITCODE."
        }
    }

    if ($SetupOnly) {
        Write-Host '==> Setup complete.' -ForegroundColor Green
        Write-Host "    API: $ApiBaseUrl"
        exit 0
    }

    $usesLocalBackend = -not $apiWasExplicit
    if ($usesLocalBackend -and -not $NoBackend -and $apiUri.Scheme -eq 'http') {
        $backendPort = if ($apiUri.IsDefaultPort) { 80 } else { $apiUri.Port }
        if (-not (Test-TcpPort -HostName '127.0.0.1' -Port $backendPort)) {
            if (-not (Test-Path -LiteralPath (Join-Path $backendRoot 'src\server.js'))) {
                throw "Backend was not found at $backendRoot"
            }
            if ($null -eq (Get-Command node -ErrorAction SilentlyContinue)) {
                throw 'Node.js was not found in PATH; the backend cannot be started.'
            }

            if (-not (Test-Path -LiteralPath (Join-Path $backendRoot 'node_modules'))) {
                if ($null -eq (Get-Command npm.cmd -ErrorAction SilentlyContinue)) {
                    throw 'npm.cmd was not found; backend dependencies cannot be installed.'
                }
                Write-Host '==> Installing backend dependencies...'
                Push-Location $backendRoot
                try {
                    & npm.cmd ci
                    if ($LASTEXITCODE -ne 0) {
                        throw "'npm ci' failed with exit code $LASTEXITCODE."
                    }
                }
                finally {
                    Pop-Location
                }
            }

            Write-Host '==> Starting the SmartShrimp backend...'
            $nodePath = (Get-Command node).Source
            $startedBackend = Start-Process `
                -FilePath $nodePath `
                -ArgumentList 'src/server.js' `
                -WorkingDirectory $backendRoot `
                -WindowStyle Hidden `
                -PassThru

            $deadline = [DateTime]::UtcNow.AddSeconds(30)
            while ([DateTime]::UtcNow -lt $deadline) {
                if ($startedBackend.HasExited) {
                    throw "Backend stopped during startup (exit code $($startedBackend.ExitCode)). Check smartshrimp_be/logs."
                }
                if (Test-TcpPort -HostName '127.0.0.1' -Port $backendPort) {
                    break
                }
                Start-Sleep -Milliseconds 500
            }

            if (-not (Test-TcpPort -HostName '127.0.0.1' -Port $backendPort)) {
                throw "Backend did not open port $backendPort in 30 seconds. Check the database and smartshrimp_be/.env."
            }
        }
        else {
            Write-Host "==> Backend is already running on port $backendPort."
        }
    }

    $flutterArguments = @(
        'run',
        '--no-pub',
        '--device-id', [string]$selectedDevice.id,
        "--dart-define=API_BASE_URL=$ApiBaseUrl"
    )

    if ($null -ne $localConfig) {
        foreach ($configName in @('CLOUDINARY_CLOUD_NAME', 'CLOUDINARY_UPLOAD_PRESET')) {
            if ($localConfig.PSObject.Properties.Name -contains $configName) {
                $configValue = [string]$localConfig.$configName
                if (-not [string]::IsNullOrWhiteSpace($configValue)) {
                    $flutterArguments += "--dart-define=$configName=$configValue"
                }
            }
        }
    }

    if ($selectedDevice.id -in @('chrome', 'edge')) {
        $flutterArguments += @('--web-hostname', 'localhost', '--web-port', '5173')
    }

    Write-Host "==> Running SmartShrimp with API $ApiBaseUrl" -ForegroundColor Cyan
    & flutter @flutterArguments
    if ($LASTEXITCODE -ne 0) {
        throw "'flutter run' failed with exit code $LASTEXITCODE."
    }
}
finally {
    if ($null -ne $startedBackend -and -not $startedBackend.HasExited) {
        Write-Host '==> Stopping the backend started by this launcher...'
        Stop-Process -Id $startedBackend.Id -Force -ErrorAction SilentlyContinue
    }
    Pop-Location
}
