# ==========================================
# PowerShell Profile ($PROFILE)
# ==========================================

# --- 1. .NET CLI Shortcuts ---
function dn   { dotnet @args }
function dnb  { dotnet build @args }
function dnr  { dotnet run @args }
function dnw  { dotnet watch run @args }
function dnt  { dotnet test @args }
function dnc  { dotnet clean @args }
function dnrs { dotnet restore @args }
function dna  { dotnet add package @args }
function dns  { dotnet sln @args }

# --- 2. Entity Framework Core Shortcuts ---
function efa  { dotnet ef migrations add @args }
function efu  { dotnet ef database update @args }
function efr  { dotnet ef migrations remove @args }
function efd  { dotnet ef database drop @args }

# --- 3. Git Shortcuts ---
function gs   { git status -s @args }
function ga   { git add @args }
function gaa  { git add . }
function gc   { git commit -m @args }
function gp   { git push @args }
function gpl  { git pull @args }
function gco  { git checkout @args }
function gb   { git branch @args }
function gl   { git log --oneline -n 15 @args }

# --- 4. Navigation & Profile Helpers ---
function ..   { Set-Location .. }
function ...  { Set-Location ..\.. }
function la   { Get-ChildItem -Force @args }
function c    { code . }
function exp  { explorer.exe . }
function ep   { notepad $PROFILE }
function rp   { . $PROFILE; Write-Host "Profile reloaded!" -ForegroundColor Green }

# --- 5. WSL Bridge ---
function u    { wsl -d Ubuntu @args }
function lx   { wsl @args }

# --- 6. Linux-Style File & Text Utilities ---
function rmrf {
    param([Parameter(Mandatory=$true)][string[]]$Path)
    Remove-Item -Path $Path -Recurse -Force
}

function ln {
    param(
        [Parameter(Mandatory=$true)][string]$Target,
        [Parameter(Mandatory=$true)][string]$LinkName
    )
    New-Item -ItemType SymbolicLink -Path $LinkName -Target (Resolve-Path $Target)
}

function touch {
    param([Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)][string[]]$Paths)
    foreach ($Path in $Paths) {
        if (Test-Path $Path) {
            (Get-Item $Path).LastWriteTime = Get-Date
        } else {
            New-Item -ItemType File -Path $Path -Force | Out-Null
        }
    }
}

function grep { Select-String @args }
function which ($cmd) { (Get-Command $cmd).Source }
function head { param($Path, $n = 10) Get-Content $Path -Head $n }
function tail { param($Path, $n = 10) Get-Content $Path -Tail $n -Wait }

function mkcd {
    param([Parameter(Mandatory=$true)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

function export {
    param([Parameter(Mandatory=$true)][string]$Pair)
    $name, $value = $Pair -split '=', 2
    Set-Item -Path "Env:$name" -Value $value
}

function env { Get-ChildItem Env: }

# --- 7. Dev Cleanup & Network Helpers ---
function nuke {
    Get-ChildItem -Include bin,obj -Recurse -Force | Remove-Item -Recurse -Force
    Write-Host "Cleaned all bin and obj folders!" -ForegroundColor Yellow
}

function killport {
    param([Parameter(Mandatory=$true)][int]$Port)
    $proc = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique
    if ($proc) {
        Stop-Process -Id $proc -Force
        Write-Host "Killed process $proc on port $Port" -ForegroundColor Green
    } else {
        Write-Host "No process found on port $Port" -ForegroundColor Yellow
    }
}

function localip { (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" -and $_.IPAddress -notlike "169.254.*" }).IPAddress }
function pubip   { (Invoke-RestMethod -Uri "https://api.ipify.org") }



function go2dev {
    param([string]$Project)
    if ($Project) {
        Set-Location "D:\GitHubRepo\$Project"
    } else {
        Set-Location "D:\GitHubRepo"
    }
}

Register-ArgumentCompleter -CommandName go2dev -ParameterName Project -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete)
    Get-ChildItem -Path "D:\GitHubRepo" -Directory |
        Where-Object { $_.Name -like "$wordToComplete*" } |
        ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.FullName) }
}

# --- 8. History Search (Up/Down Arrows) ---
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward



function vs {
    param([string]$Target = ".")
    
    # Automatically finds the latest installed Visual Studio (2022, 2026, Enterprise, Pro, or Community)
    $devenv = Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\Common7\IDE\devenv.exe" -ErrorAction SilentlyContinue | 
              Sort-Object FullName -Descending | 
              Select-Object -First 1 -ExpandProperty FullName

    if (-not $devenv) {
        Write-Host "Visual Studio (devenv.exe) not found!" -ForegroundColor Red
        return
    }

    # If you run 'vs' with no arguments, automatically open the .sln / .slnx file in the current folder
    if ($Target -eq ".") {
        $sln = Get-ChildItem -Path . -Include *.sln, *.slnx -Depth 1 | Select-Object -First 1
        if ($sln) {
            Start-Process $devenv -ArgumentList "`"$($sln.FullName)`""
            return
        }
    }

    Start-Process $devenv -ArgumentList "`"$Target`""
}
