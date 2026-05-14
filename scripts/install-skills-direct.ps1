[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$SourceSkillsDir,
    [string]$ClaudeSkillsDir = 'C:\Users\DELL\.claude\skills',
    [string]$CodexSkillsDir = 'C:\Users\DELL\.codex\skills',
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path (Join-Path $scriptDir '..')

if (-not $SourceSkillsDir) {
    $SourceSkillsDir = Join-Path $repoRoot 'skills'
}

$source = Resolve-Path $SourceSkillsDir

function Copy-SkillDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.DirectoryInfo]$Skill,
        [Parameter(Mandatory = $true)]
        [string]$DestinationRoot
    )

    $destination = Join-Path $DestinationRoot $Skill.Name

    if ((Test-Path $destination) -and -not $Force) {
        Write-Host "Skip existing: $destination (use -Force to replace)"
        return
    }

    if ($PSCmdlet.ShouldProcess($destination, "Install skill '$($Skill.Name)'")) {
        New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null

        if (Test-Path $destination) {
            Remove-Item -LiteralPath $destination -Recurse -Force
        }

        Copy-Item -LiteralPath $Skill.FullName -Destination $destination -Recurse -Force
        Write-Host "Installed: $destination"
    }
}

function Install-SkillsToTarget {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DestinationRoot
    )

    $skills = Get-ChildItem -LiteralPath $source -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
        Sort-Object Name

    foreach ($skill in $skills) {
        Copy-SkillDirectory -Skill $skill -DestinationRoot $DestinationRoot
    }
}

Write-Host "Source skills: $source"
Write-Host "Claude target: $ClaudeSkillsDir"
Write-Host "Codex target:  $CodexSkillsDir"

Install-SkillsToTarget -DestinationRoot $ClaudeSkillsDir
Install-SkillsToTarget -DestinationRoot $CodexSkillsDir
