Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$skill = Join-Path $repoRoot 'skills\drafting-pr-info-cn\SKILL.md'

if (-not (Test-Path $skill)) {
    throw 'Missing skills\drafting-pr-info-cn\SKILL.md'
}

function Utf8String {
    param([Parameter(Mandatory = $true)][string]$Hex)

    $bytes = for ($i = 0; $i -lt $Hex.Length; $i += 2) {
        [Convert]::ToByte($Hex.Substring($i, 2), 16)
    }
    return [System.Text.Encoding]::UTF8.GetString([byte[]]$bytes)
}

$content = Get-Content $skill -Raw -Encoding UTF8

$required = @(
    'name: drafting-pr-info-cn',
    'description: Use when',
    'git status --short --branch',
    'git diff --stat',
    'git log --oneline --reverse',
    (Utf8String '505220e6a087e9a298'),
    (Utf8String '5be78988e69cace58fb75d747970652873636f7065293a20e4b8ade69687e6a087e9a298'),
    (Utf8String '5b302e312e315d66656174286167656e742d7569293a20e694afe68c81e4bbaae8a1a8e79b98e7bc96e8be91e88d89e7a8bfe9a284e8a788e4b88ee4bbbbe58aa1e6b581e4bd93e9aa8ce4bc98e58c96'),
    (Utf8String 'e58f98e69bb4e8afb4e6988e'),
    (Utf8String 'e4b8bbe8a681e694b9e58aa8'),
    (Utf8String 'e5bdb1e5938de88c83e59bb4'),
    (Utf8String 'e9aa8ce8af81e696b9e5bc8f'),
    (Utf8String 'e6b3a8e6848fe4ba8be9a1b9'),
    'Do NOT run `gh pr create`',
    'untracked',
    (Utf8String 'e4b88de8a681e8999ae69e84e9aa8ce8af81e7bb93e69e9c')
)

foreach ($needle in $required) {
    if (-not $content.Contains($needle)) {
        throw "Missing required text: $needle"
    }
}

Write-Output 'PASS: drafting-pr-info-cn skill contains required PR drafting guardrails'
