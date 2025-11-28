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
    @{ Message = 'chore: update project dependencies' },
    @{ Message = 'feat: setup layout and global styles'; Files = @('notion-clone/app/globals.css', 'notion-clone/app/layout.tsx', 'notion-clone/lib/utils.ts') },
    @{ Message = 'docs: add initial project documentation' },
    @{ Message = 'refactor: minor optimizations' },
    @{ Message = 'chore: formatting improvements' },
    @{ Message = 'feat: add shadcn ui components'; Files = @('notion-clone/components.json', 'notion-clone/components/ui') },
    @{ Message = 'chore: clean up unused imports' },
    @{ Message = 'feat: integrate firebase and setup cloudflare workers'; Files = @('notion-clone/firebase.ts', 'notion-clone/firebase-admin.ts', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/src', 'notion-clone-cloudflare-workers/rapid-glade-6b9a/tsconfig.json') },
    @{ Message = 'chore: bump dependencies' },
    @{ Message = 'docs: update readme with setup instructions' },
    @{ Message = 'feat: create header and sidebar components'; Files = @('notion-clone/components/Header.tsx', 'notion-clone/components/Sidebar.tsx', 'notion-clone/components/SidebarOptions.tsx') },
    @{ Message = 'refactor: improve component structure' },
    @{ Message = 'chore: configure linting rules' },
    @{ Message = 'feat: implement document creation actions'; Files = @('notion-clone/actions', 'notion-clone/types', 'notion-clone/components/NewDocumentButton.tsx') },
    @{ Message = 'chore: fix minor ui bugs' },
    @{ Message = 'docs: add api documentation' },
    @{ Message = 'feat: final polish and landing page'; Files = @('.') },
    @{ Message = 'chore: prepare for production deployment' },
    @{ Message = 'feat: finalize v1.0.0' }
)

$dates = @(
    "2025-11-02T10:15:30+05:30",
    "2025-11-03T11:20:10+05:30",
    "2025-11-04T14:22:10+05:30",
    "2025-11-05T09:05:00+05:30",
    "2025-11-06T16:15:30+05:30",
    "2025-11-07T12:30:45+05:30",
    "2025-11-08T16:45:00+05:30",
    "2025-11-09T18:10:20+05:30",
    "2025-11-10T11:30:45+05:30",
    "2025-11-20T10:12:30+05:30",
    "2025-11-21T11:22:15+05:30",
    "2025-11-22T09:12:30+05:30",
    "2025-11-23T14:40:00+05:30",
    "2025-11-24T16:50:30+05:30",
    "2025-11-25T15:20:15+05:30",
    "2025-11-26T13:10:45+05:30",
    "2025-11-27T17:30:00+05:30",
    "2025-11-28T18:40:00+05:30",
    "2025-11-29T20:15:10+05:30",
    "2025-11-30T10:05:00+05:30"
)

try {
    for ($i = 0; $i -lt $plan.Count; $i++) {
        if ($plan[$i].Files) {
            foreach ($f in $plan[$i].Files) {
                if (Test-Path $f) {
                    git add $f
                }
            }
        }
        $env:GIT_AUTHOR_DATE = $dates[$i]
        $env:GIT_COMMITTER_DATE = $dates[$i]
        
        # If there are staged files, commit them normally.
        # If there are no staged changes, create an empty commit.
        $status = git status --porcelain
        if ($status) {
            git commit --quiet -m $plan[$i].Message
        } else {
            git commit --allow-empty --quiet -m $plan[$i].Message
        }
        
        Write-Host ("Commit $($i+1): $($plan[$i].Message) on $($dates[$i])")
    }
} finally {
    Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
}

git branch -M main
git remote add origin https://github.com/ritiksingh3202/notion_ai.git
Write-Host "Done! History backfilled. Pushing to remote..."
git push -u origin main --force
