<#
  Builds the git history for the Tiny compiler as a sequence of dated commits
  spread across a month (2-3 per day), using the files already on disk.

  Usage (from the project root):
    powershell -ExecutionPolicy Bypass -File reference\backfill-history.ps1 -DryRun
    powershell -ExecutionPolicy Bypass -File reference\backfill-history.ps1

  Markdown files are committed section by section: a stage like
  @{ Path = 'README.md'; Lines = 9 } commits only the first 9 lines, and the
  file's final stage commits it in full. All files end byte-identical to the
  originals.
#>
param(
    [int]$Year = 2026,
    [int]$Month = 8,
    [string]$TimeZone = '+05:30',
    [int]$Seed = 20260801,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function F([string]$path) { @{ Path = $path; Lines = 0 } }
function P([string]$path, [int]$lines) { @{ Path = $path; Lines = $lines } }
function C([string]$msg, [object[]]$files) { [pscustomobject]@{ Message = $msg; Files = $files } }

$plan = @(
    C 'initial setup'                        @((F '.gitignore'), (F 'Cargo.toml'))
    C 'add readme'                                 @((P 'README.md' 9))
    C 'start language docs'          @((P 'LANGUAGE.md' 13))

    C 'lexer crate'                   @((F 'crates/tiny-lexer/Cargo.toml'))
    C 'add spans'              @((F 'crates/tiny-lexer/src/span.rs'))
    C 'tokens'                          @((F 'crates/tiny-lexer/src/token.rs'))
    C 'lexer errors'                   @((F 'crates/tiny-lexer/src/error.rs'))
    C 'lexer working'                         @((F 'crates/tiny-lexer/src/lexer.rs'))
    C 'lexer lib'                     @((F 'crates/tiny-lexer/src/lib.rs'))

    C 'ast crate'                       @((F 'crates/tiny-ast/Cargo.toml'))
    C 'types'                       @((F 'crates/tiny-ast/src/ty.rs'))
    C 'expressions'                          @((F 'crates/tiny-ast/src/expr.rs'))
    C 'statements and functions'              @((F 'crates/tiny-ast/src/stmt.rs'))
    C 'ast lib'                         @((F 'crates/tiny-ast/src/lib.rs'))
    C 'grammar notes'                               @((P 'LANGUAGE.md' 45))

    C 'parser crate'                 @((F 'crates/tiny-parser/Cargo.toml'))
    C 'parse errors'                @((F 'crates/tiny-parser/src/error.rs'))
    C 'parser'         @((F 'crates/tiny-parser/src/parser.rs'))
    C 'parser lib'                  @((F 'crates/tiny-parser/src/lib.rs'))
    C 'parser tests'                      @((F 'crates/tiny-parser/tests/parse_tests.rs'))
    C 'hello world'                        @((F 'examples/hello.tiny'))
    C 'hello output'                  @((F 'examples/hello.expected'))
    C 'build steps in readme'                             @((P 'README.md' 18))

    C 'sema crate'                     @((F 'crates/tiny-sema/Cargo.toml'))
    C 'sema errors'                     @((F 'crates/tiny-sema/src/error.rs'))
    C 'symbol table'                      @((F 'crates/tiny-sema/src/symbols.rs'))
    C 'type checker'                       @((F 'crates/tiny-sema/src/typeck.rs'))
    C 'sema lib'                 @((F 'crates/tiny-sema/src/lib.rs'))
    C 'typeck tests'                       @((F 'crates/tiny-sema/tests/sema_tests.rs'))
    C 'semantics notes'                        @((P 'LANGUAGE.md' 53))

    C 'interpreter crate'                 @((F 'crates/tiny-interp/Cargo.toml'))
    C 'values'                     @((F 'crates/tiny-interp/src/value.rs'))
    C 'runtime errors'                         @((F 'crates/tiny-interp/src/error.rs'))
    C 'interpreter'           @((F 'crates/tiny-interp/src/eval.rs'))
    C 'interp lib'                     @((F 'crates/tiny-interp/src/lib.rs'))
    C 'interp tests'                      @((F 'crates/tiny-interp/tests/interp_tests.rs'))
    C 'fib example'                        @((F 'examples/fib.tiny'))
    C 'fib output'                    @((F 'examples/fib.expected'))
    C 'loops example'                              @((F 'examples/loops.tiny'))
    C 'loops output'                  @((F 'examples/loops.expected'))

    C 'ir crate'                         @((F 'crates/tiny-ir/Cargo.toml'))
    C 'ir types'                        @((F 'crates/tiny-ir/src/ir.rs'))
    C 'lowering'                                @((F 'crates/tiny-ir/src/lower.rs'))
    C 'ir lib'                              @((F 'crates/tiny-ir/src/lib.rs'))
    C 'ir tests'                             @((F 'crates/tiny-ir/tests/ir_tests.rs'))
    C 'some optimizations'                        @((F 'crates/tiny-ir/src/opt.rs'))
    C 'mixed types example'                        @((F 'examples/mixed_types.tiny'))
    C 'mixed types output'            @((F 'examples/mixed_types.expected'))

    C 'codegen crate'               @((F 'crates/tiny-codegen/Cargo.toml'))
    C 'x86 codegen'              @((F 'crates/tiny-codegen/src/x86.rs'))
    C 'codegen lib'                        @((F 'crates/tiny-codegen/src/lib.rs'))
    C 'nested return example'                      @((F 'examples/nested_ret.tiny'))
    C 'nested return output'         @((F 'examples/nested_ret.expected'))

    C 'cli crate'                       @((F 'crates/tiny-cli/Cargo.toml'))
    C 'cli'                       @((F 'crates/tiny-cli/src/main.rs'))
    C 'golden tests'                @((F 'crates/tiny-cli/tests/golden.rs'))
    C 'another example'               @((F 'examples/rec_while.tiny'))
    C 'rec_while output'              @((F 'examples/rec_while.expected'))

    C 'usage'                                  @((P 'README.md' 34))
    C 'list examples'                            @((P 'README.md' 45))
    C 'crates overview'                              @((P 'README.md' 60))
    C 'readme tests section'                           @((F 'README.md'))
    C 'pipeline docs'                         @((F 'LANGUAGE.md'))
    C 'add ci'                          @((F '.github/workflows/ci.yml'))
)

# Build the schedule: every day gets 2 commits, a few random days get a 3rd.
$days = [DateTime]::DaysInMonth($Year, $Month)
if ($plan.Count -lt 2 * $days -or $plan.Count -gt 3 * $days) {
    throw "Plan has $($plan.Count) commits; needs between $(2 * $days) and $(3 * $days) for 2-3 per day."
}
$rng = New-Object System.Random $Seed
$perDay = @(2) * $days
$extraDays = 1..$days | Sort-Object { $rng.Next() } | Select-Object -First ($plan.Count - 2 * $days)
foreach ($d in $extraDays) { $perDay[$d - 1] = 3 }

$dates = foreach ($d in 1..$days) {
    $minutes = 1..$perDay[$d - 1] | ForEach-Object { $rng.Next(10 * 60, 23 * 60 + 30) } | Sort-Object
    foreach ($m in $minutes) {
        $dt = (Get-Date -Year $Year -Month $Month -Day $d -Hour 0 -Minute 0 -Second 0).AddMinutes($m).AddSeconds($rng.Next(0, 60))
        $dt.ToString('yyyy-MM-ddTHH:mm:ss') + $TimeZone
    }
}

# Every file on disk must be covered, and every planned file must exist.
$planned = $plan.Files | ForEach-Object { $_.Path } | Sort-Object -Unique
foreach ($p in $planned) { if (-not (Test-Path $p)) { throw "Planned file missing: $p" } }

if ($DryRun) {
    for ($i = 0; $i -lt $plan.Count; $i++) {
        $files = ($plan[$i].Files | ForEach-Object { if ($_.Lines) { "$($_.Path)[1-$($_.Lines)]" } else { $_.Path } }) -join ', '
        '{0,2}  {1}  {2,-50} {3}' -f ($i + 1), $dates[$i], $plan[$i].Message, $files
    }
    return
}

if (Test-Path .git) { throw '.git already exists; refusing to rewrite an existing repository.' }
if (-not (git config user.email)) { throw 'Set git user.name and user.email before running.' }

$originals = @{}
foreach ($p in $planned) { $originals[$p] = [IO.File]::ReadAllBytes((Join-Path $root $p)) }
$backup = Join-Path ([IO.Path]::GetTempPath()) ("tiny-backup-" + [Guid]::NewGuid())
foreach ($p in $planned) {
    $dest = Join-Path $backup $p
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    [IO.File]::WriteAllBytes($dest, $originals[$p])
}
Write-Host "Backup of original files: $backup"

function Get-Prefix([byte[]]$bytes, [int]$lines) {
    $seen = 0
    for ($i = 0; $i -lt $bytes.Length; $i++) {
        if ($bytes[$i] -eq 10) { $seen++; if ($seen -eq $lines) { return $bytes[0..$i] } }
    }
    return $bytes
}

git init --quiet
git symbolic-ref HEAD refs/heads/main
Add-Content -Path .git/info/exclude -Value "reference/"

try {
    for ($i = 0; $i -lt $plan.Count; $i++) {
        foreach ($f in $plan[$i].Files) {
            $full = Join-Path $root $f.Path
            $bytes = $originals[$f.Path]
            if ($f.Lines) { $bytes = [byte[]](Get-Prefix $bytes $f.Lines) }
            [IO.File]::WriteAllBytes($full, $bytes)
            git add -- $f.Path
        }
        $env:GIT_AUTHOR_DATE = $dates[$i]
        $env:GIT_COMMITTER_DATE = $dates[$i]
        git commit --quiet -m $plan[$i].Message
        if ($LASTEXITCODE -ne 0) { throw "Commit failed: $($plan[$i].Message)" }
        Write-Host ('{0,2}/{1}  {2}  {3}' -f ($i + 1), $plan.Count, $dates[$i], $plan[$i].Message)
    }
}
finally {
    Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
    foreach ($p in $planned) { [IO.File]::WriteAllBytes((Join-Path $root $p), $originals[$p]) }
}

$untracked = git ls-files --others --exclude-standard
if ($untracked) { Write-Warning "Files not included in any commit:`n$($untracked -join "`n")" }
Write-Host "Done: $($plan.Count) commits. Add a remote and push with: git push -u origin main"
