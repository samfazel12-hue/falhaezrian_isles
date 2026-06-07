Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$QuartzDir = Join-Path $Root "_quartz"
$OutputDir = Join-Path $Root "public"

function Require-Command($Name, $InstallHint) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "$Name is not installed or not on PATH. $InstallHint"
  }
}

function Ensure-Quartz {
  $needsClone = $true

  if (Test-Path -LiteralPath $QuartzDir) {
    Push-Location $QuartzDir
    try {
      $branch = (git branch --show-current 2>$null)
      if ($branch -eq "v4") {
        $needsClone = $false
        git fetch origin v4
        git checkout -f v4
      }
    }
    finally {
      Pop-Location
    }

    if ($needsClone) {
      Write-Host "Removing existing _quartz checkout so Quartz v4 can be installed cleanly..."
      Remove-Item -LiteralPath $QuartzDir -Recurse -Force
    }
  }

  if ($needsClone) {
    Write-Host "Cloning Quartz into _quartz..."
    git clone --branch v4 https://github.com/jackyzha0/quartz.git $QuartzDir
  }

  Copy-Item -LiteralPath (Join-Path $Root "quartz.config.ts") -Destination (Join-Path $QuartzDir "quartz.config.ts") -Force
  Copy-Item -LiteralPath (Join-Path $Root "quartz.layout.ts") -Destination (Join-Path $QuartzDir "quartz.layout.ts") -Force

  Push-Location $QuartzDir
  try {
    if (-not (Test-Path -LiteralPath "node_modules")) {
      Write-Host "Installing Quartz dependencies..."
      npm install
    }
  }
  finally {
    Pop-Location
  }
}

Require-Command "node" "Install Node.js 22 LTS or newer from https://nodejs.org/"
Require-Command "npm" "Install Node.js 22 LTS or newer from https://nodejs.org/"
Require-Command "git" "Install Git for Windows from https://git-scm.com/download/win"

$NodeMajor = [int]((node -v).TrimStart("v").Split(".")[0])
if ($NodeMajor -lt 22) {
  throw "Quartz currently expects Node.js 22 or newer. Installed: $(node -v). Install Node.js 22 LTS or newer from https://nodejs.org/"
}

Ensure-Quartz

Push-Location $QuartzDir
try {
  Write-Host "Building Quartz site..."
  npx quartz build -d ".." -o "..\public"
}
finally {
  Pop-Location
}

Write-Host "Static site output: $OutputDir"
