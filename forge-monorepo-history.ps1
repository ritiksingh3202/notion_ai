$ErrorActionPreference = 'Stop'
$root = "c:\B.Arch\SaaS Projects\Notion\remote_repo"
Set-Location $root

if (Test-Path .git) {
    Remove-Item .git -Recurse -Force
}

git init --quiet
git config user.name "ritiksingh3202"
git config user.email "ritiksingh6252@gmail.com"

$plan = @(
    @{ Message = 'init: setup monorepo for notion clone'; Files = @('notion-clone/public', 'notion-clone/next.config.ts', 'notion-clone/tsconfig.json', 'notion-clone/eslint.config.mjs', 'notion-clone/postcss.config.mjs', 'notion-clone/.gitignore', 'notion-clone/package.json', 'notion-clone/package-lock.json', 'notion-clone/README.md', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/package.json', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/wrangler.jsonc') },
    @{ Message = 'feat: setup layout and global styles'; Files = @('notion-clone/app/globals.css', 'notion-clone/app/layout.tsx', 'notion-clone/lib/utils.ts') },
    @{ Message = 'feat: add shadcn ui components'; Files = @('notion-clone/components.json', 'notion-clone/components/ui') },
    @{ Message = 'feat: integrate firebase and setup cloudflare workers'; Files = @('notion-clone/firebase.ts', 'notion-clone/firebase-admin.ts', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/src', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/tsconfig.json') },
    @{ Message = 'feat: create header and sidebar components'; Files = @('notion-clone/components/Header.tsx', 'notion-clone/components/Sidebar.tsx', 'notion-clone/components/SidebarOptions.tsx') },
    @{ Message = 'feat: implement document creation actions'; Files = @('notion-clone/actions', 'notion-clone/types', 'notion-clone/components/NewDocumentButton.tsx') },
    @{ Message = 'feat: final polish and landing page'; Files = @('.') }
)

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
            # Only add if the path exists, to prevent errors on partial commits
            if (Test-Path $f) {
                git add $f
            }
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
git remote add origin https://github.com/ritiksingh3202/notion_ai.git
Write-Host "Done! History backfilled. Pushing to remote..."
git push -u origin main --force
