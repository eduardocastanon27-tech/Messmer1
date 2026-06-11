# Lessons Ledger — raw entries, one line each: SYMPTOM -> ROOT CAUSE -> RULE

## ARCHIVE — processed 2026-06-10 (BIHO CMS build session; promoted to cogito-protocol §2/§3/§4b/§5; S-rules proposed for name-systems-thinking)
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
- lessons ledger empty after richest session -> project hooks never fire when the session root is the PARENT of the repos (multi-repo session), so the seed never installed -> verify capture path at session start; reconstruct at checkpoint
- (project-specific) FerretDB+sqlite works as Mongo stand-in when fastdl.mongodb.org is blocked; *.vercel.app/api.vercel.com unreachable from Claude remote containers; Vercel deploys matched via meta.githubCommitSha
