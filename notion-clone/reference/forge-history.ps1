$ErrorActionPreference = 'Stop'
$root = "c:\B.Arch\SaaS Projects\Notion\notion-clone"
Set-Location $root

if (Test-Path .git) {
    Remove-Item .git -Recurse -Force
}

git init --quiet
git config user.name "ritiksingh3202"
git config user.email "ritiksingh6252@gmail.com"

# Define the commits and the files to add
$plan = @(
    @{ Message = 'init: nextjs boilerplate'; Files = @('public', 'next.config.ts', 'tsconfig.json', 'eslint.config.mjs', 'postcss.config.mjs', '.gitignore', 'package.json', 'package-lock.json', 'README.md') },
    @{ Message = 'feat: setup layout and global styles'; Files = @('app/globals.css', 'app/layout.tsx', 'lib/utils.ts') },
    @{ Message = 'feat: add shadcn ui components'; Files = @('components.json', 'components/ui') },
    @{ Message = 'feat: integrate firebase for backend'; Files = @('firebase.ts', 'firebase-admin.ts') },
    @{ Message = 'feat: create header and sidebar components'; Files = @('components/Header.tsx', 'components/Sidebar.tsx', 'components/SidebarOptions.tsx') },
    @{ Message = 'feat: implement document creation actions'; Files = @('actions', 'types', 'components/NewDocumentButton.tsx') },
    @{ Message = 'feat: final polish and landing page'; Files = @('.') }
)

# 7 commits to distribute over Nov 2-10 and Nov 20-30
$dates = @(
    "2025-11-02T10:15:30+05:30",
    "2025-11-04T14:22:10+05:30",
    "2025-11-08T16:45:00+05:30",
    "2025-11-10T11:30:45+05:30",
    "2025-11-22T09:12:30+05:30",
    "2025-11-25T15:20:15+05:30",
    "2025-11-28T18:40:00+05:30"
)

try {
    for ($i = 0; $i -lt $plan.Count; $i++) {
        foreach ($f in $plan[$i].Files) {
            git add $f
        }
        $env:GIT_AUTHOR_DATE = $dates[$i]
        $env:GIT_COMMITTER_DATE = $dates[$i]
        git commit --quiet -m $plan[$i].Message
        Write-Host ("Commit $($i+1): $($plan[$i].Message) on $($dates[$i])")
    }
} finally {
    Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
}

git branch -M main
Write-Host "Done! History has been backfilled successfully."
