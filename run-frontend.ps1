# PowerShell runner script for Wallet System Frontend
$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   Starting Wallet System Frontend (Vite + React) " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

$env:NODE_OPTIONS = "--use-system-ca"

Set-Location "$PSScriptRoot\frontend"
Write-Host "Starting Vite dev server at http://localhost:5173 ..." -ForegroundColor Green
& "npm.cmd" run dev
