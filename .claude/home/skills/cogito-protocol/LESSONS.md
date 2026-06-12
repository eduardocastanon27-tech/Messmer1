# Lessons Ledger — raw entries, one line each: SYMPTOM -> ROOT CAUSE -> RULE
- React inputs lost focus on every keystroke (caught in review before shipping) -> helper component was defined inside the parent component, so its type identity changed each render and React remounted the subtree -> define components at module level; pass closures as props
- sub-agent calls failed mid-task ("session limit") -> agent quota is a shared external resource that can vanish between planning and execution -> have a do-it-yourself fallback for any delegated step
- Health panel showed storage green while uploads failed -> the check probed list() (allowed on private stores) instead of the real public put() -> a health check must perform the exact operation the feature performs, not an adjacent one
- (meta) user reported most of an explanation was not understood -> answer was pitched at my vocabulary, not the reader's stated background -> calibrate explanations to the user's demonstrated vocabulary, define every term of art in plain words, and build one concept at a time
- owner set hover colors equal to base in the editor -> exposing derived values as independent knobs invites inconsistent state -> derive dependent values (color-mix) instead of exposing them as choices
- deploy log showed a scary "deprecated" warning -> transitive dep of the legacy code path; a warning is not an error -> trace provenance in the lockfile before reacting
- UI showed a phantom 50-minute "running timer"; later a command hung forever -> background tasks left uncollected, and a stray `cat` with no input read stdin indefinitely -> collect or kill every background task before going idle; never leave a command that can wait on input

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
