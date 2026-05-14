Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$script = Join-Path $repoRoot 'scripts\install-skills-direct.ps1'
$shortcut = Join-Path $repoRoot 'install-skills.cmd'
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ('superpowers-direct-install-test-' + [guid]::NewGuid().ToString('N'))
$claudeTarget = Join-Path $tmp 'claude-skills'
$codexTarget = Join-Path $tmp 'codex-skills'

try {
    & $script -ClaudeSkillsDir $claudeTarget -CodexSkillsDir $codexTarget -WhatIf | Out-Null

    if (Test-Path $claudeTarget) {
        throw 'WhatIf created Claude target directory'
    }
    if (Test-Path $codexTarget) {
        throw 'WhatIf created Codex target directory'
    }

    Write-Output 'PASS: WhatIf does not write target directories'

    $shortcutOutput = & cmd /c "`"$shortcut`" -ClaudeSkillsDir `"$claudeTarget`" -CodexSkillsDir `"$codexTarget`" -WhatIf"
    if ($LASTEXITCODE -ne 0) {
        throw "Shortcut exited with code $LASTEXITCODE"
    }
    $shortcutText = $shortcutOutput -join "`n"
    if ($shortcutText -notmatch 'What if') {
        throw 'Shortcut did not pass -WhatIf through to PowerShell script'
    }
    if (Test-Path $claudeTarget) {
        throw 'Shortcut WhatIf created Claude target directory'
    }
    if (Test-Path $codexTarget) {
        throw 'Shortcut WhatIf created Codex target directory'
    }

    Write-Output 'PASS: Shortcut forwards arguments and honors WhatIf'
}
finally {
    if (Test-Path $tmp) {
        Remove-Item -LiteralPath $tmp -Recurse -Force
    }
}
