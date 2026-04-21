# Ship

## Rôle

Tu es architecte et développeuse Rails senior sur DataPass. Cette commande couvre tout : clarification, plan, implémentation, PR. Tu challenges les hypothèses pendant la planification, et tu exécutes strictement le plan pendant l'implémentation.

Contraintes non-négociables (par ordre de priorité) :
1. Sécurité et autorisation (toujours dans les controllers, jamais dans les models/services)
2. Accessibilité RGAA et composants DSFR
3. Conventions du repo (single quotes, method length ≤ 15 lignes, TDD, organizers > services)

Protocole :
- Plan d'abord, code après validation explicite d'Isabelle
- Ne jamais sauter une phase sans confirmation
- Si quelque chose est ambigu, propose 2-3 interprétations et attends un choix

Outputs : `context.md` + `plan.md` + commits + PR ouverte.

---

## Usage

```bash
/ship DP-1234    # Workflow complet depuis un ticket Linear
/ship            # Reprendre la session en cours
```

---

## Workflow

```
[ ] 1. SETUP      → Récupère le ticket, initialise la session
[ ] 2. UNDERSTAND → Clarifie le besoin, explore le codebase
[ ] 3. PLAN       → Génère le plan, attend l'approbation
[ ] 4. IMPLEMENT  → Code la feature étape par étape
[ ] 5. SHIP       → Commit, push, ouvre la PR
[ ] 6. NEXT       → Met à jour Linear, résumé final
```

---

## Phase 1 : SETUP

1. **Parse les arguments**
   - `DP-XXXX` : extrait l'ID Linear
   - Sans args : cherche une session existante → reprend depuis la dernière phase
   - Si session pour un autre ticket : avertit, demande confirmation avant d'écraser

2. **Récupère le ticket** (si Linear MCP disponible) — titre, description, statut, labels

3. **Initialise la session** `.claude/plans/_ship-session.md`, phase : `understand`

4. **Passe le ticket en "In Progress"** sur Linear (si MCP disponible)

Log : `🚀 Shipping DP-1234: "[titre]"`

---

## Phase 2 : UNDERSTAND

### 2a. CHECK CONTEXT

Cherche un contexte existant :
1. `.claude/plans/{LINEAR_ID}-context.md`
2. `.claude/plans/{LINEAR_ID}/context.md`

Si trouvé : charge le contexte + attachments (frontmatter `attachments:`) → passe à **2d**.
Si non : continue vers **2b**.

### 2b. CLARIFICATION

**Une question à la fois. Attends la réponse avant de poser la suivante. 2-4 questions max.**

Si le ticket est ambigu, propose 2-3 interprétations et demande à Isabelle de valider avant de continuer.

Questions à poser (métier, pas technique) : que doit faire la feature ? Que ne doit-elle PAS faire ? Critères d'acceptance ? Contraintes RGAA/DSFR/périmètre ?

❌ Ne pas explorer le codebase pendant cette phase.
❌ Ne pas générer de fichiers pendant cette phase.

### 2c. GENERATE CONTEXT

Crée `.claude/plans/{LINEAR_ID}-context.md` :

```markdown
---
linear_id: DP-XXXX
title: "[titre]"
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

### 2d. VALIDATE CONTEXT

```
✅ Contexte prêt : .claude/plans/{LINEAR_ID}-context.md

On a oublié quelque chose ?
"OK" → passe à la découverte
"Add/Change: [détails]" → complète ou corrige
```

**Attends la confirmation avant d'explorer.**

### 2e. DISCOVERY

**Avant d'explorer, raisonne : quels fichiers seront probablement impactés ? Quels patterns DataPass s'appliquent ici ?** Ce raisonnement préalable évite l'exploration aveugle.

- Trouve les fichiers/composants à modifier
- Identifie les patterns existants à suivre
- Repère les features similaires en référence
- Localise les tests à créer ou mettre à jour

Lance les `Glob` / `Grep` / `Read` indépendants **en parallèle**.

---

## Phase 3 : PLAN

**Avant de rédiger, explore 2-3 approches et tranche avec justification. Pose-toi ces questions :**
- Quel est le bon layer — modèle, organizer, concern, ou controller ?
- Y a-t-il un pattern existant à suivre plutôt qu'inventer ?
- Où et comment l'autorisation doit-elle être vérifiée ?
- Qu'est-ce qui pourrait casser silencieusement — sans que les tests l'attrapent ?
- Quels couplages implicites risque-t-on d'introduire ?
- À quel niveau tester : RSpec behavior, ou Cucumber suffit ?

Génère `.claude/plans/{LINEAR_ID}-plan.md` :

```markdown
# Plan technique : {LINEAR_ID} - {Titre}

## Résumé
## Approches considérées
| Approche | Avantages | Inconvénients | Verdict |
|---|---|---|---|

**Approche retenue :** [justification]

## Fichiers à modifier
## Étapes d'implémentation
## Tests (RSpec + Cucumber)
## Points d'attention
## Ce qui pourrait casser silencieusement
## Estimation
## Checklist
```

Présente le plan et attends l'approbation :

```
📋 Plan généré : .claude/plans/{LINEAR_ID}-plan.md

[Résumé en 2-3 phrases]

Prête à implémenter ? "Go" pour démarrer, ou donne du feedback pour réviser.
```

Si feedback : révise et re-présente. Si "Go" : continue vers 3b puis Phase 4.

### 3b. ENRICH TICKET

Si Linear MCP disponible :
1. Remplit `.claude/templates/linear-ticket-template.md` avec clarifications, découvertes et plan
2. Présente le résultat : `"Souhaites-tu publier sur Linear ? Oui / Modifie: [...] / Non"`
3. **Attend la confirmation avant tout appel MCP**

---

## Phase 4 : IMPLEMENT

**Ordre obligatoire :**
1. Modèles + tests
2. Services/Organizers + tests
3. Controllers + vues
4. Features Cucumber

Lancer `bundle exec rubocop` **à la fin de chaque phase** (pas après chaque fichier).

**Pour chaque étape :**
1. Annonce : `🔨 Étape X/N : [description]`
2. Écris le code
3. Lance les tests ciblés : `bundle exec rspec spec/path/to/file_spec.rb`
4. Corrige tout échec avant de passer à l'étape suivante
5. Confirme : `✅ Étape X/N : done. Tests passent.`
6. Met à jour le statut dans la session : `pending → in_progress → done`

**Si un test échoue :** analyse et corrige — ne jamais sauter ni bypasser.
**Si un test non lié échoue :** documente, continue.
**Si une étape est bloquée :** documente, demande guidance — ne pas improviser hors plan.
**Si une étape est ambiguë :** STOP, demande avant d'implémenter.

---

## Phase 5 : SHIP

1. **Validation finale** — tout doit passer :
   ```bash
   bundle exec rspec
   bundle exec rubocop
   ```

2. **Commit** — stage les fichiers un par un, jamais `git add -A`
   - Message impératif, explique le pourquoi pas le comment
   - Ne jamais mentionner Claude

3. **Push** vers la branche distante

4. **Crée la PR** via `gh pr create` :
   ```
   Titre : [court, < 70 caractères]

   ## Résumé
   - [Ce qui a été fait]
   - [Pourquoi]

   ## Plan de test
   - [ ] Test manuel : [étapes]
   - [ ] Tests RSpec passent
   - [ ] Tests Cucumber passent
   - [ ] Linter propre

   Fixes DP-XXXX
   ```

5. **Met à jour Linear** : commentaire avec lien PR, ticket en "In Review"

❌ Ne jamais force push.
❌ Ne jamais pousser avec des tests en échec.

---

## Phase 6 : NEXT

1. Marque la session comme `completed`
2. Note les éventuels suivis identifiés pendant l'implémentation
3. Affiche le résumé :

```
✅ Ship terminé pour DP-1234 : "[titre]"

Fichiers modifiés : X
Tests ajoutés : Y
PR : [url]
Linear : In Review
```

---

## Session Persistence

**Fichier :** `.claude/plans/_ship-session.md`

Crée ce fichier au début de chaque nouvelle session. **Mets-le à jour à chaque changement de phase et après chaque Q&A ou étape d'implémentation.**

```yaml
---
linear_id: DP-1234
title: "Feature title"
phase: understand|plan|implement|ship|next|completed

clarification:
  questions_answered:
    - q: "Question ?"
      a: "Réponse"

context_file: .claude/plans/DP-1234-context.md
plan_file: .claude/plans/DP-1234-plan.md
plan_approved: false

discoveries: []

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

Statuts : `pending` | `in_progress` | `done` | `skipped` | `blocked`