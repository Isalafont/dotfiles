# Plan

## 🎯 Quand utiliser cette commande

Tu veux **préparer le travail sans coder aujourd'hui** : clarifier le besoin, explorer le code, générer un plan.

Les tickets DataPass sont toujours minimaux — la clarification est toujours incluse.

| Tu veux... | Commande |
|---|---|
| **Juste préparer (pas coder aujourd'hui)** | **`/plan`** ← tu es ici |
| Coder à partir d'un plan déjà validé | `/implement-plan` |
| Aller du ticket à la PR en une session | `/ship` |

Cas d'usage typiques :
- Planning en début de semaine
- Ticket à discuter avec l'équipe avant de coder
- Feature complexe où tu veux valider l'approche avant de te lancer

---

## 📋 Usage

```bash
/plan DP-1234              # Plan from Linear ticket
/plan path/to/spec.md      # Plan from specification file
/plan                      # Resume current planning session
```

---

## 🔄 Workflow Overview

This command follows a structured workflow to create a comprehensive plan:

1. **FETCH** - Get ticket/specification
2. **CHECK CONTEXT** - Look for existing context file
3. **CLARIFICATION** - Ask business questions (sequential, one at a time)
4. **GENERATE CONTEXT** - Create context.md with business requirements
5. **VALIDATE CONTEXT** - User reviews context before exploration
6. **DISCOVERY** - Explore codebase in targeted manner
7. **PLAN GENERATION** - Create detailed technical plan

---

## 📝 Detailed Instructions

### Phase 1: FETCH

**If LINEAR_ID provided (e.g., DP-1234):**
- Use Linear MCP to fetch ticket if available
- Extract: title, description, comments, status
- Log: "Fetched Linear ticket DP-1234: [title]"

**If FILE provided:**
- Read the specification file
- Extract requirements and context

**If no arguments (resume mode):**
- Check for `.claude/plans/_plan-session.md`
- Load session state and continue from last phase
- If no session exists, prompt user for LINEAR_ID or FILE

### Phase 2: CHECK CONTEXT + LOAD ATTACHMENTS

Look for existing context file in priority order:

1. `.claude/plans/{LINEAR_ID}/context.md` (e.g., DP-1234/context.md) - directory structure
2. `.claude/plans/{LINEAR_ID}-context.md` (e.g., DP-1234-context.md) - flat structure
3. `.claude/plans/{filename}-context.md` (if FILE provided)
4. User-provided context file path

**If context file exists:**

1. **Read context file**
   - Log: "✅ Found context: [path]"

2. **Parse and load attachments** (if any)

   Look for attachments in frontmatter:
   ```yaml
   ---
   attachments:
     - path/to/file.md
     - path/to/directory/
   ---
   ```

   **For each attachment:**

   a) **Resolve path** (relative to project root)

   b) **Check if file or directory:**
      - If file: Read directly
      - If directory: Find all `.md` files recursively

   c) **Load and log:**
   ```
   ✅ Loading attachments...

      📁 note_datapass/Recherche/shaping-fc/
         → decisions.md (2.1 KB)
         → alternatives.md (1.5 KB)

      📄 note_datapass/Recherche/investigation.md (4.5 KB)

   ✅ Context loaded: 3 files (8.1 KB total)
   ```

   d) **Store content in session context**

   **Attachment rules:**
   - Paths are relative to project root
   - For directories: load all `.md` files recursively
   - Ignore non-markdown files
   - Log each file loaded with size
   - If attachment not found, log warning but continue

3. **Parse references section** (optional fallback)

   Look for "## Références" section with file paths:
   ```markdown
   ## Références
   - Shaping: ./shaping.md
   - Research: note_datapass/Recherche/research.md
   ```

   Load these files as well if not already in attachments.

4. **Context ready**
   - Log: "✅ Context loaded with N attachments"
   - Skip to Phase 5 (VALIDATE CONTEXT)

**If no context file:**
- Log: "No existing context file found"
- Continue to Phase 3 (CLARIFICATION)

### Phase 3: CLARIFICATION (Sequential)

**CRITICAL: Ask ONE question at a time, wait for answer, then ask next question.**

**Initial assessment:**
- Analyze ticket/spec to understand what's missing
- Identify business questions that need answers

**Question guidelines:**
- Focus on business requirements, not technical details
- Ask about:
  - What exactly should the feature do?
  - What should it NOT do?
  - Acceptance criteria
  - Constraints (RGAA, DSFR, etc.)
  - Edge cases
  - User experience expectations

**Process:**
1. Generate Question 1
2. Ask the question clearly
3. **WAIT for user response** (do NOT continue)
4. Save answer in session
5. Generate Question 2
6. Ask the question
7. **WAIT for user response**
8. Repeat until all clarifications obtained

**DO NOT:**
- ❌ Ask multiple questions at once
- ❌ Start exploring codebase during clarification
- ❌ Generate files during clarification
- ❌ Move to next phase until all answers received

**Session tracking:**
```yaml
phase: clarification
current_question: 2
total_questions: 4
questions_answered:
  - q1: "What should the feature do?"
    a1: "User answer..."
  - q2: "What are the constraints?"
    a2: "User answer..."
```

### Phase 4: GENERATE CONTEXT

**After all clarifications received**, create context file:

**File location:** `.claude/plans/{LINEAR_ID}/context.md` or `.claude/plans/{LINEAR_ID}-context.md`

**Structure:**
```markdown
---
linear_id: DP-1234
title: "Feature title"
type: feature|bugfix|refactor
created: YYYY-MM-DD
attachments:
  - note_datapass/Recherche/shaping-fc/              # Directory: all .md files
  - note_datapass/Recherche/investigation.md # Single file
  - docs/features/fc-integration/   # Another directory
---

# Contexte métier

## Besoin
[2-3 sentence description]

## Que doit faire la feature
- Action 1
- Action 2

## Que NE doit PAS faire la feature
- Not action 1
- Not action 2

## Critères d'acceptance
1. When X, then Y
2. When Z, then W

## Contraintes

**DSFR:** [Components to use]
**RGAA:** [Accessibility constraints]
**Périmètre:** [Impacted areas]

## Questions / Clarifications
[All Q&A from Phase 3]

## Références
- Linear: [URL]
- Figma: [URL]
- Shaping: See attachments (note_datapass/Recherche/shaping-fc/)
- Research: See attachments (note_datapass/Recherche/)
```

**Log:** "Context file created: .claude/plans/{LINEAR_ID}-context.md"

### Phase 5: VALIDATE CONTEXT

**Present context to user for validation:**

```
✅ Context file created: .claude/plans/{LINEAR_ID}-context.md

Please review the context file to ensure we didn't miss anything:
- Business requirements complete?
- Acceptance criteria clear?
- Constraints identified?

Reply:
- "OK" or "Good" to proceed to discovery
- "Add: [details]" to add missing information
- "Change: [details]" to correct something
```

**Wait for user confirmation.**

**If user adds/changes:**
- Update context.md
- Ask if anything else to add
- Wait for final "OK"

**Only after user confirms** → Move to Phase 6

### Phase 6: DISCOVERY

**Now explore the codebase in a targeted manner.**

**Based on context, identify:**
1. Files/components that will be modified
2. Existing patterns to follow
3. Similar features for reference
4. Tests to update/create

**Use tools efficiently:**
- `Glob` for finding files by name/pattern
- `Grep` for searching code content
- `Read` for reading relevant files

**What to discover:**
- Current implementation patterns
- Naming conventions
- Test structure
- I18n key locations
- Component architecture

**Log discoveries in session:**
```yaml
discoveries:
  - "Found HeaderComponent in app/components/organisms/"
  - "Pattern: use dsfr_tooltip helper"
  - "Tests: spec/components/organisms/"
  - "I18n keys: config/locales/authorization_request_forms/"
```

**DO NOT generate plan yet** - just explore and gather information.

### Phase 7: PLAN GENERATION

**Create detailed technical plan:**

**File location:** `.claude/plans/{LINEAR_ID}-plan.md`

**Structure:**
```markdown
# Plan technique : {LINEAR_ID} - {Title}

## 🎯 Résumé
[1-2 sentences]

## 📋 Approche technique
[Chosen approach with rationale]

## 📁 Fichiers à modifier
1. `path/to/file.rb` - [What changes]
2. `path/to/test.rb` - [What tests]

## 🔨 Étapes d'implémentation

### Étape 1: [Step name]
**Fichier:** `path/to/file`

**Code to add/modify:**
```ruby
# Example code
```

### Étape 2: [Step name]
[...]

## 🧪 Tests
- RSpec: [Which tests]
- Cucumber: [Which scenarios]

## ⚠️ Points d'attention
1. [Important consideration]
2. [Edge case to handle]

## 📊 Estimation
X points (Y hours)
- Breakdown...

## ✅ Checklist
- [ ] Implementation done
- [ ] Tests pass
- [ ] Linter clean
- [ ] Manual testing
```

**Log:** "Plan generated: .claude/plans/{LINEAR_ID}-plan.md"

**Update session status:** `status: ready`

---

### Phase 8: ENRICH TICKET

**If Linear MCP available and ticket was fetched:**

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

5. **If skipped:** log `linear_enriched: false` in session, continue.

**DO NOT update Linear without user confirmation.**

---

## 💾 Session Persistence

**Session file:** `.claude/plans/_plan-session.md`

**Tracked state:**
```yaml
---
linear_id: DP-1234
phase: clarification|validate_context|discovery|plan_generation|completed
status: pending|has-questions|ready
current_question: 2
questions_answered:
  - [Q&A pairs]
discoveries:
  - [Discovery notes]
files:
  context: .claude/plans/DP-1234-context.md
  plan: .claude/plans/DP-1234-plan.md
---
```

**Resume behavior (`/plan` without args):**
- Read session file
- Continue from current phase
- Restore context (questions answered, discoveries made)

---

## 📊 Status Tracking

Update ticket status (if Linear MCP available):
- Start: `In Progress`
- Plan ready: Comment with link to plan file
- After implementation: `Done`

---

## ⚠️ Important Rules

### During CLARIFICATION:
- ✅ Ask ONE question at a time
- ✅ Wait for complete answer
- ✅ Save each Q&A in session
- ❌ DO NOT explore codebase
- ❌ DO NOT generate files
- ❌ DO NOT ask multiple questions at once

### During VALIDATE CONTEXT:
- ✅ Wait for user confirmation
- ✅ Allow adding/modifying context
- ❌ DO NOT proceed to discovery without confirmation

### During DISCOVERY:
- ✅ Explore in targeted manner (know what you're looking for)
- ✅ Log all discoveries
- ❌ DO NOT explore blindly

### During PLAN GENERATION:
- ✅ Create detailed, actionable plan
- ✅ Include code examples where helpful
- ✅ Realistic time estimates

---

## 💡 Examples

### Example 1: Plan from Linear ticket
```
User: /plan DP-1491

You:
1. Fetch ticket "Ajouter les CGUs FranceConnect"
2. No context file found
3. Ask clarification questions (one at a time)
4. Generate context.md
5. Ask user to validate
6. Explore codebase
7. Generate plan.md
```

### Example 2: Plan with existing context
```
User: /plan DP-1491

You:
1. Fetch ticket
2. Found existing context file
3. Ask user to validate context
4. Explore codebase
5. Generate plan.md
```

### Example 4: Plan with attachments
```
User: /plan DP-1234

You:
✅ Fetched Linear ticket DP-1234
✅ Found context: .claude/plans/DP-1234/context.md
✅ Loading attachments...

   📁 note_datapass/Recherche/shaping-fc/
      → decisions.md (2.1 KB)
      → alternatives.md (1.5 KB)
      → maquettes.md (3.2 KB)

   📄 note_datapass/Recherche/cgu-investigation.md (4.5 KB)

✅ Context loaded: 4 files (11.3 KB total)

Now I have full context including:
- Business requirements (context.md)
- Shaping decisions and alternatives
- Technical investigation results

Proceeding to validate context...
```

### Example 3: Resume session
```
User: /plan

You:
1. Read session: phase=clarification, current_question=2
2. Continue asking questions from where we left off
```

---

## 🎯 Success Criteria

A good plan includes:
- ✅ Clear business context (from clarifications)
- ✅ Technical approach with rationale
- ✅ List of files to modify with explanations
- ✅ Step-by-step implementation guide
- ✅ Test strategy (RSpec + Cucumber)
- ✅ Points of attention / edge cases
- ✅ Realistic time estimate
- ✅ Checklist for completion

---

## 🔗 Related Commands

- `/implement-plan` - Execute the plan
- `/ship` - Complete workflow (plan + implement + PR)
- `/replan` - Revise existing plan after feedback