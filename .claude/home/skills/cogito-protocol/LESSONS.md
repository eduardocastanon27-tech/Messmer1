# Lessons Ledger — raw entries, one line each: SYMPTOM -> ROOT CAUSE -> RULE

## ARCHIVE

### 2026-06-11 — BIHO CMS build session; promoted to cogito-protocol §2/§3/§4b/§5 and name-systems-thinking (Day One patterns + debugging table)
- publish reported success while deploys failed -> success hardcoded, Vercel errors swallowed -> never report success you did not observe
- gitignore .env* silently dropped .env.example from every commit -> git add exit code is not commit proof -> verify with git ls-files
- npm install landed dep in parent dir; local builds passed, clean build failed -> Node resolves upward, masking the miss -> verify dep in the project's own package.json + clean-room build before shipping
- api.vercel.com "403" was the egress proxy, not Vercel -> middlebox impersonated API error -> check transport before logic
- valid GitHub PAT returned 404 on existing repo -> token lacked repo in its access list -> 404 + valid token = scope, not absence
- pgrep -f "found" a dead service by matching its own command line -> proxy check -> verify by port/health, not process name
- dotted content keys crashed Mongo insert -> field-name constraints invisible to TypeScript -> round-trip real data through the real store early; store blobs as JSON strings
- one DB outage bricked all later requests -> rejected connect promise cached forever -> never cache failed initialization
- contact form failed showing nothing -> error path had no UI surface -> every catch needs a visible surface
- client-side gate password shipped in JS bundle -> client auth is decoration -> authorization is server-side only
- env vars added but build lacked them -> NEXT_PUBLIC bakes at build; env changes need redeploy -> a change exists only when the build can see it
- lessons ledger empty after richest session -> session-start hook never installed the skill -> verify capture path at session start; reconstruct at checkpoint
- (project-specific) FerretDB+sqlite works as Mongo stand-in when fastdl.mongodb.org is blocked; *.vercel.app/api.vercel.com unreachable from Claude remote containers; Vercel deploys matched via meta.githubCommitSha

### 2026-06-11 — folded into name-systems-thinking SKILL.md
- "Can't delete the default branch" error on a throwaway work branch -> the first branch pushed to an empty GitHub repo becomes its default, regardless of configured default name -> when seeding an empty repo, establish `main` first (or switch default immediately) before pushing work branches. (→ Day One patterns: repo bootstrap order)
- Could not open the requested PR -> empty repo had no base branch, and PRs need a base sharing history with the head -> in a fresh repo, create a root commit on `main` and build branches on top of it before promising PRs. (→ Day One patterns: repo bootstrap order)

### 2026-06-10 — folded into cogito-protocol SKILL.md
- git push --delete reported "Everything up-to-date" but the remote branch survived -> the session's git proxy silently drops ref deletions -> verify remote mutations with `git ls-remote`, never trust push output across a proxy. (→ §5 Solve vs. ask)
- Cross-repo copy of .claude setup was denied at both the MCP layer and the git proxy -> remote sessions are hard-scoped to the session's repos, so private sources are unreachable exactly when needed -> keep shared personal setup in a public template repo (or checked-in seed) that any session can fetch anonymously. (→ Core stance)
- This ledger stayed empty through four loggable events -> lessons were narrated in chat but never written to the file at the moment they occurred -> append to LESSONS.md the moment a lesson happens, not retrospectively at session end. (→ §4b)
