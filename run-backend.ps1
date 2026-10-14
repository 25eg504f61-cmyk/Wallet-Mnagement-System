# PowerShell runner script for Wallet System Backend
param(
    [string]$DbPassword = $env:DB_PASSWORD,
    [string]$Profile = ""
)

$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Starting Wallet System Backend (Spring Boot)   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# Set JDK 17
if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
}
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
$env:MAVEN_OPTS = "-Djavax.net.ssl.trustStoreType=WINDOWS-ROOT"

# Determine profile
if ($Profile -eq "h2") {
    $env:SPRING_PROFILES_ACTIVE = "h2"
    Write-Host "Mode: Embedded Database (H2 persisted mode)" -ForegroundColor Yellow
} elseif ($DbPassword) {
    $env:DB_PASSWORD = $DbPassword
    $env:SPRING_PROFILES_ACTIVE = "default"
    Write-Host "Mode: MySQL 8.0 (Using supplied password)" -ForegroundColor Green
} else {
    # Check if local MySQL accepts default password 'root'
    $mysqlTest = & "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -proot -e "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        $env:SPRING_PROFILES_ACTIVE = "default"
        Write-Host "Mode: MySQL 8.0 (Connected with default credentials)" -ForegroundColor Green
    } else {
        Write-Host "Notice: Local MySQL root password was not recognized." -ForegroundColor Yellow
        Write-Host "Starting with embedded database mode (H2 persisted) so the backend runs immediately!" -ForegroundColor Cyan
        Write-Host "To connect to MySQL instead, run: .\run-backend.ps1 -DbPassword <your_mysql_password>`n" -ForegroundColor Gray
        $env:SPRING_PROFILES_ACTIVE = "h2"
    }
}

Set-Location "$PSScriptRoot\backend"
Write-Host "Launching Spring Boot on http://localhost:8082 ...`n" -ForegroundColor Green
& ".\mvnw.cmd" spring-boot:run
