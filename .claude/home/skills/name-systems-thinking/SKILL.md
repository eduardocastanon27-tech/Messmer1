---
name: name-systems-thinking
description: "description: Apply systems thinking before starting or modifying a project. Use when the user asks to build a new project, add a feature, change a value (color, copy, config), or debug a problem. Enforces the principle that every change is a system change — audit sources of truth, layer ownership, and downstream impact before writing code."
---

# Systems Thinking Skill

Before writing any code, map the system. A change at one layer silently breaks everything below it.

## The Three Questions (ask every time)

1. **Where is the single source of truth?** If it doesn't exist, create it before building anything that depends on it.
2. **What layer does this belong to?** Data → Tokens/Config → Components → Layout/Pages. Changes flow downward. Never skip a layer.
3. **What breaks downstream?** Identify every consumer of the thing being changed before touching it.

---

## Workflow

Make a todo list for all the tasks in this workflow and work through them in order.

### 1. Map the Sources of Truth

Read the codebase to identify where authoritative values live:
- Business/content strings → is there a `constants.ts` or equivalent?
- Visual values (colors, spacing, fonts) → is there a design tokens file?
- Configuration (API keys, feature flags, URLs) → is there an env/config layer?

If any of these are missing and the task will touch those values, **create the source of truth first**, then build the feature against it.

### 2. Identify the Layer

Classify the requested change:
- **Data layer** — constants, copy, business logic values
- **Token/Config layer** — design tokens, environment config, theme values
- **Component layer** — UI components, hooks, utilities
- **Layout/Route layer** — page composition, routing, server components

The fix or feature lives in exactly one layer. Patching the wrong layer creates two bugs.

### 3. Audit Downstream Consumers

Before changing anything, grep for every consumer of the thing being changed:
- If changing a token → find every component that references it
- If changing a constant → find every file that imports it
- If changing a component API → find every call site

For each consumer, answer: **does this change break it, and in what context?**

### 4. Check for Context-Dependent Behavior

Some values behave differently depending on context. Common cases:
- **Color on different backgrounds** — a color that passes WCAG AA contrast on dark backgrounds may fail on white. Audit by background context, not just by value.
- **Font size in different containers** — a size that works in a wide section may overflow in a narrow sidebar.
- **Z-index in different stacking contexts** — a modal that works on the home page may be buried under a sticky header on another page.

If context-dependence exists, **add a derivative token or variant** rather than a one-off override.

### 5. Propagate, Don't Patch

After identifying all consumers and contexts:
- Update the source of truth first
- Let the change propagate to consumers — don't override at the component level
- If a consumer needs different behavior in a specific context, encode that in the token/variant system, not as an inline exception

### 6. Verify the System

After changes:
- Type-check: `npx tsc --noEmit`
- Build: `npm run build` (or equivalent)
- Visually verify affected components across all background contexts
- Check contrast ratios if any color changed

Both must pass clean before committing.

---

## Debugging Protocol

When diagnosing a bug, name the layer before proposing a fix:

| Symptom | Layer | Where to look |
|---|---|---|
| Type error, missing export | Build | `tsc` output, import paths |
| Page returns 404 / blank | Serve/Adapter | Framework config, deployment config |
| Wrong value rendered | Data | Constants file, props passed |
| Visual wrong but value correct | Token/CSS | Token file, Tailwind class, specificity |
| Works locally, broken in prod | Environment | Env vars, build-time vs runtime — `NEXT_PUBLIC_*`-style vars bake in at build, so an env change exists only once a build can see it (redeploy after adding) |

Never apply a fix at layer N+1 when the bug is at layer N.

---

## Common Patterns to Establish on Day One

These prevent entire classes of problems. Create them before writing features:

**`constants.ts`** — all business strings, slugs, labels. A hardcoded string in a component is a bug.

**`design-tokens.css` (or equivalent)** — all brand values as named variables. Raw hex/rgb in component code is a bug.

**Two-role token split** — for any value used in multiple contexts (e.g., an accent color used as both a background and as text on white), define two tokens: one for the background role, one for the text-on-light role. Never assume one value works in both contexts.

**`vercel.json` / deployment config** — set `"framework"` explicitly. Missing framework config causes CDN-level failures that produce zero runtime logs — the hardest class of bug to diagnose.

**Repo bootstrap order** — in an empty GitHub repo, push `main` with a root commit before any work branch: the first branch pushed becomes the default branch (set by the event, not by repo settings), and PRs are impossible until a base branch exists. When host state looks wrong, check what *is* (`git ls-remote`, the settings page), not what was configured.

**Server-side authorization only** — anything enforced in client JS ships its secret in the bundle; a client-side gate is UX decoration, never security. The server check is the boundary.

**Visible error surfaces** — every catch block must surface somewhere the user or operator can see (UI state, toast, log). An error path with no surface produces "failed showing nothing", the slowest class of bug to even notice.

**Round-trip real data through the real store early** — datastores have constraints invisible to the type system (e.g., Mongo rejects dotted field names). Insert representative real data on day one; store freeform content blobs as JSON strings rather than nested keys.

**Never cache failed initialization** — a memoized connect/init promise that rejected poisons every later request until restart. Cache only successes; let failures retry.

---

## Wrap Up

After completing the task, report:

1. **Source of truth used** — which file was the authoritative source, or which new file was created
2. **Layer of the change** — where in the stack the change lives
3. **Consumers audited** — how many call sites / components were checked
4. **Context variants found** — any cases where the same value needed different treatment by context
5. **Verification** — tsc and build result

If any downstream consumer was found to be broken and left unfixed, flag it explicitly.
