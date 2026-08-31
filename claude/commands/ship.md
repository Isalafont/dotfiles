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
/ship DPP-42          # Workflow complet depuis un ticket Linear
/ship "corriger le libellé du scope FranceConnect"   # Sans ticket — il sera proposé en 3b
/ship                 # Reprendre la session en cours
```

---

## Workflow

```
[ ] 1. SETUP      → Récupère le ticket, initialise la session
[ ] 2. UNDERSTAND → Clarifie le besoin, explore le codebase
[ ] 3. PLAN       → Génère le plan, attend l'approbation
[ ] 4. IMPLEMENT  → Code la feature étape par étape (agent implementer)
[ ] 4b. REVIEW    → code-reviewer → implementer applique (boucle, max 2 tours)
[ ] 4c. A11Y      → rgaa-auditor → implementer applique (bloquant + majeur)
[ ] 4d. PRÉ-PR    → feature-finisher (brakeman, conventions, doc) → implementer si bloquant
[ ] 4e. STOP      → Récap + diff affiché, attend « Go »
[ ] 5a. COMMITS   → Découpage par intention proposé, attend validation ⏸
[ ] 5b. PUSH      → Commande donnée, Isabelle pousse ⏸
[ ] 5c. PR        → Corps affiché en entier, attend validation ⏸
[ ] 6. NEXT       → Session close, suivis notés, résumé final
```

---

## Phase 1 : SETUP

1. **Parse les arguments**
   - `DPP-XX` / `DP-XXXX` / `API-XXXX` : extrait l'ID Linear
   - **Texte libre entre guillemets** : démarrage sans ticket. Le sujet devient le
     titre de travail, la session est marquée `sans_ticket: true`, et la création
     du ticket est proposée en phase 3b une fois le cadrage fait — au bon moment,
     quand on sait ce qu'on écrit dedans.
   - Sans args : cherche une session existante → reprend depuis la dernière phase
   - Si session pour un autre ticket : avertit, demande confirmation avant d'écraser

2. **Récupère le ticket** (si Linear MCP disponible) — titre, description, statut, labels

3. **Initialise la session** `.claude/plans/_ship-session.md`, phase : `understand`

4. **Ne touche jamais au statut Linear.** L'intégration GitHub s'en charge :
   « In Progress » au push de la PR, « In Review » quand la PR y passe. Le faire
   par MCP produit un doublon, aux deux bouts de la chaîne.

Log : `🚀 Shipping DPP-42: "[titre]"`

---

## Phase 2 : UNDERSTAND

### 2a. CHECK CONTEXT

Cherche un contexte existant (`.claude/plans/{LINEAR_ID}-context.md` ou `.claude/plans/{LINEAR_ID}/context.md`). Si trouvé : charge-le + attachments (frontmatter `attachments:`) → **2d**. Sinon → **2b**.

### 2b. CLARIFICATION

**Une question à la fois. Attends la réponse avant de poser la suivante. 2-4 questions max.**

Si le ticket est ambigu, propose 2-3 interprétations et demande à Isabelle de valider avant de continuer.

Questions à poser (métier, pas technique) : que doit faire la feature ? Que ne doit-elle PAS faire ? Critères d'acceptance ? Contraintes RGAA/DSFR/périmètre ?

Pendant cette phase : ni exploration du codebase, ni génération de fichiers.

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
- Quel est le bon layer — modèle, organizer, concern, ou controller ? Un pattern existant à suivre plutôt qu'inventer ?
- Où et comment l'autorisation doit-elle être vérifiée ?
- Qu'est-ce qui pourrait casser silencieusement ou coupler implicitement — hors du regard des tests ?
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

Pour chaque étape : code → tests ciblés (`bundle exec rspec spec/path/to/file_spec.rb`) → corrige les échecs avant de continuer, et mets à jour le statut de la session (`pending → in_progress → done`).

Un test lié en échec se corrige, jamais se contourne. Un test non lié se documente et on continue. Une étape bloquée ou ambiguë : STOP, demande — pas d'improvisation hors plan.

---

## Phase 4b : REVIEW → APPLY (boucle, max 2 tours)

Chaîne automatique après l'implémentation. **Aucun arrêt humain dans la boucle review** : les arrêts commencent en 4e, puis à chaque sous-phase de SHIP.

**Boucle, max 2 tours :**

1. **Review** — spawne le sous-agent `code-reviewer` (`subagent_type: code-reviewer`) sur la diff complète de la branche. Il retourne un verdict ✅/⚠️/🚫 avec bloquants chiffrés.
2. **Évalue le verdict :**
   - ✅ **Prête** — sortir de la boucle, passer en Phase 4c.
   - ⚠️ / 🚫 — passer à l'étape 3 (apply).
3. **Apply** — spawne `implementer` (`subagent_type: implementer`) avec le rapport reviewer. Il applique **uniquement** les bloquants 🚫 + les ⚠️ retenus, relance les tests ciblés, ne sort pas du périmètre du plan.
4. **Re-review** — relance l'étape 1.
   - Si ✅ → sortir.
   - Sinon, **2ᵉ tour maximum**. Au bout du 2ᵉ tour encore non ✅ : **stopper le workflow**, session en phase `review-pending`, afficher le rapport restant à Isabelle. Reprendre via `/replan` ou correction manuelle.

Phase obligatoire : elle attrape les régressions silencieuses, les couplages implicites et les violations sécurité que les tests verts ne voient pas.

---

## Phase 4c : A11Y AUDIT → APPLY

Si la diff touche des **vues, composants ou formulaires** (`app/views/`, `app/components/`, `.erb`) :

1. **Audit** — spawne `rgaa-auditor` (`subagent_type: rgaa-auditor`) sur les fichiers front touchés. Il écrit un rapport priorisé dans `.claude/audit/`.
2. **Apply** — spawne `implementer` avec le rapport a11y. Il applique les corrections de niveau **bloquant ET majeur** (laisse les mineurs en suggestion dans le résumé final), relance les tests ciblés.
3. **Re-vérifie** — si l'audit avait des bloquants, relance `rgaa-auditor` une fois pour confirmer la résolution.

Si la diff ne touche aucun fichier front : sauter cette phase, le noter dans le résumé.

❌ DataPass est un service public : la conformité RGAA est une obligation légale. Ne pas sauter l'audit quand du front est touché.

---

## Phase 4d : CHECK PRÉ-PR

Dernier contrôle automatique avant le stop humain, sur ce qui n'a été vérifié
nulle part ailleurs dans la chaîne.

1. **Check** — spawne `feature-finisher` (`subagent_type: feature-finisher`) sur la branche.
   Il lance brakeman, contrôle les conventions DataPass, vérifie la cohérence
   doc/tutoriel si l'API est touchée, et écrit son rapport dans `.claude/audit/`.
   **Condition d'arrêt** : il ne corrige rien et ne commit rien — il rapporte.
2. **Apply** — s'il remonte des bloquants 🚫, spawne `implementer` avec son rapport.
   Les points mineurs restent en suggestion dans le récap final.

Précisions :
- L'étape accessibilité de `feature-finisher` fait doublon avec la phase 4c —
  lui indiquer de la sauter quand 4c a déjà tourné.
- Il ne relance ni rspec, ni cucumber, ni rubocop : ils ont déjà tourné en 4 et 4b.

---

## Phase 4e : STOP HUMAIN — récap et diff

Avant tout commit/push, présente à Isabelle le récap de la chaîne :

```
🧪 Chaîne review/a11y terminée pour DP-XXXX

Review  : N tour(s) — verdict final ✅
  Appliqué : [liste des corrections]
  Écarté   : [liste + pourquoi]
A11y    : [audité / sauté car pas de front]
  Appliqué (bloquant+majeur) : [liste]
  Mineurs laissés en suggestion : [liste]

Pré-PR : brakeman ✅  conventions ✅  doc/tutoriel [à jour / n.a.]
```

Puis **affiche le diff**, pas son décompte :

```bash
git diff develop...HEAD --stat
```

Isabelle relit le diff avant tout commit — c'est une règle de son CLAUDE.md
global, pas une option. Si elle demande le détail d'un fichier, montre-le.

```
Je passe en SHIP ? « Go » / feedback.
```

**Attends « Go » avant la Phase 5.**

---

## Phase 5 : SHIP

Trois sous-phases, **trois arrêts**. Ne jamais les enchaîner d'un seul « Go » :
Isabelle valide le découpage, déclenche le push, et relit le corps de la PR.

Pas de revalidation complète ici : rspec et rubocop ont tourné en phase 4 et 4b,
brakeman et les conventions en 4d. Les relancer allongerait la chaîne sans rien
apprendre.

### 5a. Découpage en commits → **arrêt**

`/ship` ne produit **jamais un seul commit fourre-tout**. Découpe par intention :
un commit par changement qui se raconte seul, dans l'ordre où on le relirait.

Propose le découpage avant d'écrire quoi que ce soit :

```
📦 Découpage proposé — N commits

1. <message impératif>
   <fichiers>
2. <message impératif>
   <fichiers>

OK pour ce découpage ? « Go » / « regroupe 2 et 3 » / « sépare 1 »
```

Puis, sur accord : stage les fichiers **un par un**, jamais `git add -A`.

**Messages courts.** Une ligne à l'impératif, 72 caractères maximum, et rien
d'autre. Pas de corps de message par défaut, pas de justification, pas de
reformulation de ce que le diff montre déjà. On n'ajoute un corps que si une
décision non lisible dans le code doit être tracée — et alors deux lignes
suffisent. Jamais de mention de Claude.

```
✅  Borne les tentatives de webhook à 10 essais
✅  Mise à jour de la doc et du tutoriel
❌  Met à jour la documentation des webhooks pour refléter la nouvelle borne
    de 10 tentatives introduite par ce changement, ainsi que le tutoriel
```

Après les commits, montre `git log develop..HEAD --oneline` et **arrête-toi**.

### 5b. Push → **arrêt**

Ne pousse pas de toi-même. Donne la commande :

```
🚀 Prêt à pousser. Lance :
! git push -u origin <branche>

Ou dis « pousse » si tu veux que je le fasse.
```

Isabelle pousse à la main par défaut. Attends que le push soit fait avant 5c.

### 5c. Corps de la PR → **arrêt**

Rédige le corps, **affiche-le en entier**, attends validation avant `gh pr create` :

```
Titre : <Type> DPP-XX — [court, < 70 caractères au total]
        Type : Fixes · Feature · Refactor · Chore · Docs

## Résumé
- [Ce qui a été fait]
- [Pourquoi]

## Plan de test
- [ ] Test manuel : [étapes]
- [ ] Tests RSpec passent
- [ ] Tests Cucumber passent
- [ ] Linter propre
```

⚠️ **L'identifiant du ticket doit figurer dans le titre de la PR.** Linear est
branché sur GitHub : il passe le ticket en « In Review » et rattache la PR tout
seul dès qu'il reconnaît l'identifiant. Sans lui dans le titre, l'automatisme ne
part pas et le ticket reste en arrière.

❌ **Ne touche pas à Linear après création de la PR** — pas de commentaire de
lien, pas de changement de statut par MCP. L'intégration s'en charge, et le
faire à la main produit un doublon.

❌ Ne jamais force push.
❌ Ne jamais pousser avec des tests en échec.
❌ Ne jamais enchaîner 5a, 5b et 5c sans arrêt intermédiaire.

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
Linear : In Review (via l’intégration GitHub)
```

---

## Session Persistence

**Fichier :** `.claude/plans/_ship-session.md`

Crée ce fichier au début de chaque nouvelle session. **Mets-le à jour à chaque changement de phase et après chaque Q&A ou étape d'implémentation.**

```yaml
---
linear_id: DP-1234
title: "Feature title"
phase: understand|plan|implement|review|review-pending|a11y|ship|next|completed

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