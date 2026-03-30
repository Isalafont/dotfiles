# Ship

## 🎯 Quand utiliser cette commande

Tu es prête à **aller au bout dans cette session** : clarifier le besoin, planifier, coder et ouvrir la PR.

Les tickets DataPass sont toujours minimaux — la clarification est toujours incluse.

| Tu veux... | Commande |
|---|---|
| Juste préparer (pas coder aujourd'hui) | `/plan` |
| Coder à partir d'un plan déjà validé | `/implement-plan` |
| **Aller du ticket à la PR en une session** | **`/ship`** ← tu es ici |

---

## 📋 Usage

```bash
/ship DP-1234    # Full workflow from Linear ticket
/ship            # Resume current ship session
```

---

## 🔄 Workflow Overview

```
[ ] 1. SETUP      → Fetch ticket, initialize session
[ ] 2. UNDERSTAND → Clarify requirements, explore codebase
[ ] 3. PLAN       → Generate plan, wait for approval
[ ] 4. IMPLEMENT  → Code the feature step by step
[ ] 5. SHIP       → Commit, push, create PR
[ ] 6. NEXT       → Update Linear, cleanup, summary
```

---

## 📝 Detailed Instructions

### Phase 1: SETUP

**Steps:**

1. **Parse arguments**
   - If `DP-XXXX`: extract Linear ID
   - If no args: check for existing session → resume from last phase
   - If session exists for a different ticket: warn, ask to overwrite

2. **Fetch ticket** (if Linear MCP available)
   - Extract: title, description, status, labels

3. **Initialize session**
   - Create `.claude/plans/_ship-session.md`
   - Set `phase: understand`

4. **Update Linear status** (if MCP available)
   - Move ticket to "In Progress"

**Log:**
```
🚀 Shipping DP-1234: "[title]"
```

---

### Phase 2: UNDERSTAND

**Objectives:** Clarify requirements, then explore codebase.

#### 2a. CHECK CONTEXT

Look for existing context file:
1. `.claude/plans/{LINEAR_ID}-context.md`
2. `.claude/plans/{LINEAR_ID}/context.md`

If found: load context + attachments (frontmatter `attachments:` field) → skip to **2d**
If not found: continue to **2b**

#### 2b. CLARIFICATION (Sequential)

**CRITICAL: One question at a time. Wait for answer. Do not continue until answered.**

- Analyze ticket to identify missing business information
- Focus questions on: what should it do, what should it NOT do, acceptance criteria, constraints (DSFR, RGAA)
- Save each Q&A in session before asking next question

**DO NOT:**
- ❌ Ask multiple questions at once
- ❌ Explore codebase during clarification
- ❌ Generate files during clarification

#### 2c. GENERATE CONTEXT

After all answers received, create `.claude/plans/{LINEAR_ID}-context.md`:

```markdown
---
linear_id: DP-XXXX
title: "[title]"
type: feature|bugfix|refactor
created: YYYY-MM-DD
---

# Contexte métier

## Besoin
## Que doit faire la feature
## Que NE doit PAS faire la feature
## Critères d'acceptance
## Contraintes (DSFR, RGAA, périmètre)
## Questions / Clarifications
```

#### 2d. VALIDATE CONTEXT

Present context to user:

```
✅ Context ready: .claude/plans/{LINEAR_ID}-context.md

Relis le contexte — on a oublié quelque chose ?
Reply "OK" to proceed, or "Add/Change: [details]"
```

**Wait for confirmation before exploring.**

#### 2e. DISCOVERY

Targeted codebase exploration based on what we now know:
- Find files/components to modify
- Identify existing patterns to follow
- Locate similar features for reference
- Find tests to update/create
- Note I18n key locations

Log all findings in session.

---

### Phase 3: PLAN

1. **Generate plan** → `.claude/plans/{LINEAR_ID}-plan.md`

   Structure:
   - Technical approach + rationale
   - Files to modify
   - Step-by-step implementation (with code examples)
   - Test strategy (RSpec + Cucumber)
   - Points of attention / edge cases
   - Time estimate

2. **Present plan** and wait for approval:

```
📋 Plan generated: .claude/plans/{LINEAR_ID}-plan.md

[Brief summary]

Ready to implement? Reply "Go" to start, or give feedback to revise.
```

3. **If feedback:** revise plan, re-present
4. **If "Go":** proceed to ENRICH TICKET, then Phase 4

#### 3b. ENRICH TICKET

**If Linear MCP available:**

1. **Fill template** from `.claude/templates/linear-ticket-template.md` using:
   - Clarifications → Contexte métier, Acceptance Criteria, Contraintes
   - Discoveries → Technical Details (fichiers à modifier/créer, points d'attention)
   - Plan → Travaux à réaliser, Estimation, Dependencies

2. **Present to user for review:**
```
📋 Ticket enrichi pour {LINEAR_ID}

[Contenu du template rempli]

Souhaites-tu publier cette description sur Linear ?
- "Oui" → update description via MCP
- "Modifie: [détails]" → ajuster puis republier
- "Non" → skip (ticket Linear non modifié)
```

3. **Wait for user response before any MCP call.**

4. **If approved (or after adjustments):** update Linear ticket description via MCP.

5. **If skipped:** log `linear_enriched: false` in session, continue to Phase 4.

**DO NOT update Linear without user confirmation.**

---

### Phase 4: IMPLEMENT

**Implementation order (mandatory per CLAUDE.md):**
1. Models + tests
2. Services/Organizers + tests
3. Controllers + views
4. Cucumber features

**For each step:**

```
🔨 Step X/N: [description]
```

1. Write the code
2. Run targeted tests: `make tests spec/path/to/file_spec.rb`
3. Run linter: `make lint`
4. Fix any failure before moving to next step
5. Update step status in session: `pending → in_progress → done`

**If a test fails:**
- Analyze and fix it — do not skip or bypass
- If unrelated pre-existing failure: document it, continue

**If a step is blocked:**
- Document the blocker in session
- Ask user for guidance
- Do not hack around it

**Progress log:**
```
✅ Step 1/4: Models done. Tests pass.
🔨 Step 2/4: Creating organizer...
```

---

### Phase 5: SHIP

1. **Final validation** — all must pass before continuing:
   ```bash
   make tests
   make lint
   ```

2. **Commit**
   - Stage specific files (never `git add -A` or `git add .`)
   - Meaningful message: imperative mood, explain why not how
   - Never mention Claude in commit messages

3. **Push** to remote branch

4. **Create PR** via `gh pr create`:

   ```
   Title: [short, < 70 chars]

   ## Summary
   - [What was done]
   - [Why]

   ## Test plan
   - [ ] Manual testing: [steps]
   - [ ] RSpec tests pass
   - [ ] Cucumber tests pass
   - [ ] Linter clean

   Fixes DP-XXXX
   ```

5. **Update Linear** (if MCP available)
   - Add comment with PR link
   - Move ticket to "In Review"

---

### Phase 6: NEXT

1. **Mark session as completed**

2. **Print summary:**
```
✅ Ship complete for DP-1234: "[title]"

📋 Files modified: X
🧪 Tests added: Y
🔗 PR: [url]
📌 Linear: In Review
```

3. **Note any follow-up work** identified during implementation

---

## 💾 Session Persistence

**File:** `.claude/plans/_ship-session.md`

```yaml
---
linear_id: DP-1234
title: "Feature title"
phase: understand|plan|implement|ship|next|completed

clarification:
  questions_answered:
    - q: "Question?"
      a: "Answer"

context_file: .claude/plans/DP-1234-context.md
plan_file: .claude/plans/DP-1234-plan.md
plan_approved: false

discoveries:
  - "Found X in app/components/..."
  - "Pattern: use Y helper"

implementation_steps:
  - id: 1
    description: "Add migration"
    status: done
  - id: 2
    description: "Create organizer"
    status: in_progress

branch: ""
pr_url: ""
---
```

**Resume (`/ship` without args):** read session, continue from current phase.

---

## 📊 Step Statuses

```
[ ] pending
[>] in_progress
[x] done
[-] skipped
[!] blocked
```

---

## ⚠️ Critical Rules

### UNDERSTAND
- ✅ ONE clarification question at a time
- ✅ Validate context before discovery
- ❌ Never explore codebase during clarification

### IMPLEMENT
- ✅ Follow CLAUDE.md implementation order (models → services → controllers → cucumber)
- ✅ Run tests after each step, fix before moving on
- ❌ Never skip failing tests
- ❌ Never use `--no-verify` or bypass hooks
- ❌ Never implement everything then test all at once

### SHIP
- ✅ All tests must pass before pushing
- ✅ Meaningful commit messages, no Claude mention
- ❌ Never force push
- ❌ Never push with failing tests

---

## 🔗 Related Commands

- `/plan` — Plan only (no implementation)
- `/implement-plan` — Implement an existing plan
- `/review` — Review a PR
- `/deploy-check` — Run full validation