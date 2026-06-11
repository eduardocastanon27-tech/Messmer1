# Cogito Operating Manual

*Read this 3+ times. A self-quiz for active recall is at the bottom. Written
in plain words on purpose — if any line needs a dictionary, that's a bug;
report it and it gets rewritten.*

---

## 1. The One Idea (if you remember nothing else)

**The thinking unit is not you and not Claude. It is YOU + CLAUDE + THE FILES.**

- Your brain brings: intuition, judgment, taste, corrections, goals.
- Claude brings: knowledge, speed, drafting, execution.
- The files bring: **memory** — the only part of the system that survives
  everything (session death, model upgrades, your own forgetting).

Anything memory-shaped goes in a file. Never in your head, never only in chat.

---

## 2. The Machine's Parts (what exists and where it lives)

| Part | What it is | Where it lives |
|---|---|---|
| SKILL.md (cogito-protocol) | The rulebook Claude follows | Messmer1 repo → auto-installed every session |
| SKILL.md (systems-thinking) | The rulebook for code projects | Same |
| LESSONS.md | The ledger: every mistake, one line each | Same |
| CLAUDE.md | Standing orders (log lessons silently, etc.) | Same |
| Checkpoint file | One-page save-game of a project | Written into each project when you say "checkpoint" |
| The hook | Auto-installer that runs at session start | `.claude/hooks/` in every repo carrying the template |

**One canonical home: the Messmer1 repo.** Edit skills only there — every
other repo pulls the latest copy automatically at session start.

---

## 3. Division of Labor (this is how you spend LESS brain power)

Your job is five things. Claude does everything else.

**YOUR JOB:**
1. **Start** sessions and say what you want (one or two sentences is enough).
2. **Correct** anything wrong, immediately and bluntly. Corrections are the
   fuel of the whole system — each one becomes a permanent rule.
3. **Decide** when asked. Claude must bring you decisions, not homework.
4. **Say "checkpoint"** before leaving, and whenever a session feels long or foggy.
5. **Verify the big claims.** When Claude says "deployed and working," ask to
   see proof once in a while. Trust, but spot-check.

**CLAUDE'S JOB (you should never have to do these — if you are, say so):**
- State its assumption before solving, and ask when unsure.
- Keep a state file during big tasks.
- Log lessons to the ledger the moment they happen, silently.
- Verify outcomes (the deploy READY, not just the push done).
- Write the checkpoint file on command.
- Ask for help explicitly ("HELP REQUESTED: ...") instead of faking.

---

## 4. The Session Loop (four moves, every time)

### Move 1 — OPEN
- New project: *"Build X. Cogito."* (the word guarantees the protocol loads;
  big tasks trigger it anyway)
- Continuing: *"Read the checkpoint file and continue."*
- **Watch for two things in the first minute:**
  - The session log shows `Restoring ~/.claude` → the hook ran, memory is loaded.
  - Claude states its assumption about what you want. If it dives straight
    into code, ask: *"What are you assuming?"*

### Move 2 — WORK
- Correct freely. Don't soften it. "No, that's wrong because X" is a gift.
- Don't manage the process — manage the outcome. You say what; Claude owns how.
- If something feels off twice, say it. Twice = pattern = lesson.

### Move 3 — CLOSE
- Say **"checkpoint."** Claude writes the one-page save-game: decisions made,
  current state, open questions, your corrections.
- Do this even mid-task if the session is getting long. A long session gets
  silently compressed and starts forgetting — checkpoint BEFORE that happens.

### Move 4 — RESTART (the counterintuitive one)
- A fresh session + checkpoint file beats continuing a long session.
  Cheaper, sharper, no accumulated fog. Don't be loyal to a conversation —
  be loyal to the files.

---

## 5. The Phrasebook (everything you ever need to say)

1. **"Cogito."** — activate the full protocol on a task.
2. **"Checkpoint."** — write the save-game file.
3. **"Read the checkpoint file and continue."** — resume a project.
4. **"Log this lesson: ..."** — force a ledger entry (corrections log automatically).
5. **"Fold the lessons into the skills."** — when ~5 lessons pile up, promote
   them into permanent rules (do this every few weeks).
6. **"Copy the .claude setup from my public Messmer1 repo into this repo,
   make the hook executable, commit, and push."** — retrofit any old repo
   into the system, once, forever.

---

## 6. Warning Signs (the system is failing — act)

| You notice | It means | You say |
|---|---|---|
| Claude claims success, shows no proof | Verification skipped | "Show me the evidence it works." |
| Claude re-asks things it knew | Context compressed, memory fading | "Checkpoint." Then restart. |
| Rich session, ledger still empty | Capture path broken | "What lessons should be logged from this session?" |
| No `Restoring ~/.claude` at start | Hook didn't run; protocol not loaded | "Run the session-start hook, then read the cogito skill." |
| You explained the same preference twice | It belongs in a file, not in chat | "Add that to CLAUDE.md in Messmer1." |

---

## 7. Maintenance Rhythm

- **Every session:** corrections happen → lessons get logged (automatic).
- **Every project pause:** "checkpoint."
- **Every few weeks:** "fold the lessons into the skills" — and prune: a rule
  that never fires gets deleted. The skill must stay short to stay loaded.
- **Rarely:** edit skills directly in Messmer1. Never edit copies elsewhere.

---

## 8. Self-Quiz (active recall — answer from memory, then check above)

1. What are the three components of the thinking unit?
2. What is the ONLY part of the system that survives sessions, model
   upgrades, and your forgetting?
3. What are your five jobs? (Claude does everything else.)
4. What two things do you watch for in the first minute of a session?
5. What word do you say before leaving any work session?
6. Why is restarting a fresh session better than continuing a long one?
7. What happens to a correction you make? (Trace its full path.)
8. When do you say "fold the lessons into the skills"?
9. Where is the ONE place skills get edited?
10. Claude says "deployed successfully" with no evidence. What do you say?

**Scoring:** 10/10 twice in a row, a week apart = you run cogito on autopilot
and your brain power goes to the work itself. That's the whole point.
