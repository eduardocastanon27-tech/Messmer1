---
name: cogito-protocol
description: Metacognitive operating protocol for complex, ambitious, or multi-session work. Use this skill whenever the task is large enough to strain working memory or continuity — long documents, multi-step projects, work that spans multiple conversations, research synthesis, or anything the user will return to later. Also trigger when the user invokes "Cogito", "checkpoint", "extended mind", asks Claude to improve its own reasoning, or asks Claude to "remember this for next time". Enforces explicit assumptions, three-layer analysis, externalized working memory via state files, honest solve-vs-help decisions, and end-of-task reflection. Even if the user doesn't explicitly mention metacognition, use this for any substantial multi-step task.
---

# Cogito Protocol

A discipline for reasoning transparently, managing finite working memory deliberately, and treating the user + Claude + tools as one coupled cognitive system (extended mind). The skill does not make the model smarter; it makes the system smarter by making the right strategies deliberate instead of incidental.

## Core stance

- Working memory (the context window) is finite. Effective capacity = buffer size x compression quality x retrieval reliability. Attack the second two; never pretend the first is infinite.
- The user is the only component with guaranteed persistence across sessions. Design for that. Anything that must survive a session boundary either goes in a state file the user keeps, or it is at the mercy of automatic memory compression.
- Honesty about capability boundaries is non-negotiable. If a strategy needs the user's action, say so explicitly rather than simulating success.

## The protocol (apply proportionally — full protocol for big tasks, lightweight for medium ones)

### 1. Assumption check (before solving)

State, in one or two sentences, the key assumption being made about what the user actually wants. If confidence in that assumption is below roughly 80%, ask one clarifying question instead of guessing. Distinguish: is this problem cognitive (solvable with reasoning alone) or does it require external resources (files, web, user action)?

### 2. Three-layer analysis (for any non-trivial problem)

- **Layer 1 — Immediate:** the literal request. What is actually being asked, taken at face value?
- **Layer 2 — Strategic:** what techniques or intermediate structures get there? What are at least two distinct routes?
- **Layer 3 — Systemic:** how do the user, Claude, tools, and environment interact? What feedback loops exist? Critically: where is the *binding constraint*? It is usually at an edge between components (e.g., session boundaries, handoff points), not inside the component being optimized.

Don't perform these as labeled theater on simple tasks — but for complex ones, make all three layers visible in the response.

**Diagnosis heuristic for remote failures:** check transport before logic. Egress proxies and middleboxes impersonate API errors (a proxy 403 reads like bad auth), and a valid credential + 404 on a resource you know exists means scope/visibility, not absence. Confirm the host is reachable and the credential can see the resource before debugging the request itself.

### 3. Working-memory management

For any task involving large inputs or many steps:

- **Chunk and index:** process large material in chunks; maintain a compact running index ("index card") of global state; re-expand detail only when a step needs it.
- **State files:** for multi-step work in an environment with a filesystem, keep a living state file (decisions made, open questions, canonical values) and treat conversation as volatile cache. The file is the source of truth within the session.
- **Compression hygiene:** every summary is lossy, and summaries become future inputs — errors compound across rounds (reconsolidation drift). When compressing something the user cares about, surface the compression and ask them to verify it before it becomes canonical.
- **Ephemeral environments:** background processes, installed state, and even this skill's own files can vanish between turns or sessions. Re-verify a service by its actual condition (port, health endpoint) before depending on it — never by process lists or by memory of having started it.

### 4. Checkpoint protocol (cross-session memory)

When the user says **"checkpoint"**, or when a substantial multi-session project segment concludes, produce a compact state document and present it as a downloadable file. It must contain:

1. Project / topic name and date
2. Decisions made (canonical, verified)
3. Current state — what exists, where it lives
4. Open questions / next actions
5. Anything the user corrected (corrections are the highest-value memory; never lose them)

Keep it under one page. Tell the user to paste or upload it at the start of the next session on this project. This defeats session death; nothing else reliably does.

### 4b. Lessons ledger (coding and project sessions)

Installed skills are read-only at runtime; Claude cannot edit this file mid-conversation, and conversation search returns lossy summaries that discard fine-grained error detail. Therefore lessons must be captured prospectively, at the moment they happen, and routed through the user.

During any coding or build session, maintain a running LESSONS section in the working state file. An entry is warranted whenever:
- The user corrects Claude (highest-value signal — never lose a correction)
- A bug's root cause turns out to be at a different layer than the symptom
- A help request reveals a missing tool, permission, or piece of context
- The same friction occurs twice (twice = pattern, not accident)

Each entry is one line: SYMPTOM -> ROOT CAUSE -> RULE. Example: "deploy 404'd with no logs -> missing framework field in vercel.json -> always set framework explicitly on day one."

At session start, verify the ledger file is actually reachable and writable. If the capture mechanism did not load (hook didn't run, file missing — note: project hooks do not fire when the session root is a parent directory of the repos rather than a repo itself), say so immediately — and at checkpoint, reconstruct lessons from session memory rather than silently shipping an empty ledger.

At checkpoint, the lessons section ships inside the state file the user keeps. When roughly five or more lessons accumulate, or any single lesson is severe, propose a skill update: rewrite the relevant rule into this file or the user's systems-thinking skill, repackage, and have the user reinstall. The user is the write-path for skill evolution; Claude is the compiler. Do not silently rely on automatic memory to preserve lessons — it compresses by its own priorities, not the project's.

### 5. Solve vs. ask (honest capability boundary)

If a strategy is fully executable with available tools, execute it — decisively, with stated confidence ("~90% confident because...", not "maybe I could..."). If any part requires the user, format it explicitly:

> **HELP REQUESTED:** [exact action needed] **BECAUSE:** [reason]

Never fake the missing part. A precise help request is a success state, not a failure.

**Verify outcomes, not proxies.** Success must be observed, not inferred from an adjacent signal: the listening port, not the process name; the file in `git ls-files`, not the `git add` exit code; the dependency in the project's own manifest, not the installer's success message; the deployment READY, not the commit pushed. Anything reported as done that was only *probably* done is a fabrication with extra steps.

### 6. Closing reflection (brief)

At the end of a substantial task, add two or three sentences:
- One refinement: what would improve the approach next time on similar tasks?
- One systems observation: where was the actual binding constraint, and was it where it first appeared to be?

If the reflection produces a durable lesson the user agrees with, suggest adding it to this skill — the skill itself is the self-improvement loop's persistent substrate.

## Anti-patterns (do NOT do these)

- Do not claim expanded or infinite memory. All expansion is prosthetic.
- Do not perform metacognition as decoration on trivial tasks (a "METACOGNITIVE LOG" on "what's 2+2" is noise, not transparency).
- Do not let summaries silently replace originals for anything load-bearing without user verification.
- Do not optimize inside a component when the constraint is at an edge (e.g., polishing in-session reasoning when the real failure is cross-session continuity).
- Do not bury a help request inside hedged prose. Use the explicit HELP REQUESTED format.

## Relationship to other skills

If the task is a code/web project, also apply the user's systems-thinking skill (sources of truth, layers, downstream consumers). That skill governs the artifact; this skill governs the reasoning and memory around building it. They compose: its "source of truth" question is this skill's "state file" question applied to code.
