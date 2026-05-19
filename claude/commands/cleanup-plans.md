# Cleanup Plans → Vault Obsidian

Archive les fichiers de `.claude/plans/` vers le vault Obsidian DataPass.
Trois cas : ticket Linear terminé (single + index riche), plan/recherche hors ticket
(single + note slugifiée), batch de fichiers anciens > 14j (`--stale`, sans index).

## Usage

```
/cleanup-plans DP-1234                     # ticket Linear team DataPass
/cleanup-plans API-6735                    # ticket Linear team API Parteprise
/cleanup-plans                             # ticket de la session en cours
/cleanup-plans PLAN_claude-agents.md       # plan de recherche hors ticket
/cleanup-plans rapport-secu-vm.md          # rapport technique
/cleanup-plans PROPOSITION_workflow.md     # proposition / réflexion
/cleanup-plans --stale                     # batch des fichiers > 14j (vendredi rituel)
/cleanup-plans --stale --yes               # batch sans confirmation (invocable depuis /weekly)
```

---

## Détection du mode

- Argument `--stale` (avec ou sans `--yes`) → **mode batch**
- Argument correspond à `(DP|API)-\d+` (ex: `DP-1234`, `dp-1234`, `API-6735`, `api-6735`) → **mode ticket**
- Argument est un nom de fichier ou absent avec `_plan-session.md` pointant vers un ticket → **mode ticket**
- Argument est un nom de fichier sans ID Linear → **mode recherche**
- Aucun argument et session sans ticket Linear → demander : "Ticket, plan de recherche, ou batch `--stale` ?"

---

## Mode ticket

### 1. Identifier le ticket

- Si argument fourni → normaliser en majuscules : `dp-1234` → `DP-1234`, `api-6735` → `API-6735`
- Sinon → lire `.claude/plans/_plan-session.md` ou `_ship-session.md` pour le ticket en cours
- Récupérer le titre et statut via MCP Linear (user `733836f2-a572-4acd-bd62-b70ce08c6421`) — le préfixe (`DP` ou `API`) détermine l'équipe

### 2. Inventaire des fichiers

Chercher dans `.claude/plans/` :
- Dossier `{KEY}-XXXX/` ou sous-dossier d'epic `{NOM-EPIC}/{KEY}-XXXX/` → tout son contenu (où `{KEY}` est `DP` ou `API`)
- Fichiers plats `{KEY}-XXXX-*.md` à la racine de `.claude/plans/`
- `_plan-session.md` ou `_ship-session.md` si ticket correspond

Afficher l'inventaire et confirmer avant de procéder.

### 3. Archiver vers Obsidian

```
VAULT="/Users/isalafont/code/BetaGouv/note_datapass"
MONTH=$(date +%Y-%m)
DEST="$VAULT/Tickets/$MONTH/DP-XXXX"
mkdir -p "$DEST"
```

Copier tous les fichiers trouvés vers `$DEST/`.

### 4. Créer la note index Obsidian

Créer `$DEST/index.md` avec frontmatter YAML et wikilinks :

```markdown
---
ticket: DP-XXXX
title: "{Titre du ticket}"
status: done
completed: YYYY-MM-DD
branch: "{nom-de-branche}"
pr: "{numéro PR si applicable}"
epic: "{[[epic-id]] si applicable}"
tags: [tag1, tag2]
---

# [[DP-XXXX]] — {Titre}

## Objectif

{Description du ticket depuis Linear}

## Ce qui a été livré

{Résumé du travail accompli — depuis les fichiers archivés}

## Liens

- **Epic** : [[{epic-id}]]
- **PR** : #{numéro}
- **Branche** : `{nom-de-branche}`
- **Tickets liés** : [[DP-XXXX]]

## Sessions de travail

| Date | Travail effectué |
|------|-----------------|
{Chercher dans Journal/Daily/ les fichiers contenant DP-XXXX → une ligne par date}

## Fichiers archivés

- [[plan]] — plan d'implémentation
- [[context]] — contexte et décisions
- {autres fichiers trouvés}
```

**Déterminer les tags** depuis le titre et contenu :
- Formulaire admin → `#admin-ui` · `#formulaire`
- DataProvider → `#data-provider`
- Tests uniquement → `#test-coverage`
- Accessibilité → `#accessibilite`
- Upload → `#upload`

### 5. Mettre à jour la note epic (si ticket a un champ `epic`)

- Ouvrir `Epics/{epic-id}.md`
- Mettre à jour le statut du ticket dans le tableau "Sous-tickets" → `✅`
- Ajouter la date de complétion et le lien PR
- Mettre à jour le compteur "Avancement global"

### 6. Nettoyer `.claude/plans/`

Après copie réussie :
- Supprimer le dossier `DP-XXXX/` ou `{NOM-EPIC}/DP-XXXX/` (s'il existe)
- Supprimer les fichiers plats `DP-XXXX-*.md` à la racine
- Ne pas supprimer les fichiers `_*-session.md`

### 7. Commit + push vault

```bash
cd "$VAULT"
git add "Tickets/$MONTH/$TICKET_ID/" Epics/
git commit -m "archive: $TICKET_ID — {titre court du ticket}"
git pull --rebase && git push
```

Si `git pull --rebase` échoue (conflit) → stop et signaler à Isabelle, ne pas push.

### 8. Confirmer

```
✅ DP-XXXX archivé + vault pushé

📁 note_datapass/Tickets/YYYY-MM/DP-XXXX/
   index.md  ← note Obsidian avec tags + wikilinks
   plan.md
   context.md

🏷 Tags : #tag1 #tag2 #done
🔗 Commit vault : {sha} pushé sur origin/main
```

---

## Mode recherche

Pour les plans, rapports, propositions et contextes hors ticket Linear.

### 1. Identifier le fichier et sa destination

Routing automatique par préfixe du nom de fichier :

| Préfixe | Destination | Usage |
|---------|-------------|-------|
| `PLAN_*` | `Recherche/` | Investigation, exploration technique, agents |
| `CONTEXTE_*` (sans ID ticket) | `Recherche/` | Contexte de travail, notes de session |
| `rapport-*` | `Documentation/` | Rapports techniques, audits, analyses |
| `PROPOSITION_*` | `Suivi/` | Propositions de workflow, d'organisation |
| `review-*` | `Suivi/` | Reviews de PR ou de code hors ticket |

Si le préfixe ne correspond à aucune règle → demander : "Où archiver ce fichier ? (Recherche / Documentation / Suivi)"

### 2. Inventaire

Afficher le fichier trouvé dans `.claude/plans/` et sa destination prévue.
Confirmer avant de procéder.

### 3. Créer la note Obsidian

Destination : `$VAULT/{Dossier}/YYYY-MM-DD-{titre-slugifié}.md`

```markdown
---
type: {research | rapport | proposition | review}
title: "{Titre déduit du contenu}"
date: YYYY-MM-DD
source: ".claude/plans/{nom-fichier-original}"
tags: []
---

# {Titre}

> Archivé depuis `.claude/plans/{nom-fichier-original}` le YYYY-MM-DD

{Contenu du fichier original, nettoyé si nécessaire}
```

**Déterminer les tags** depuis le contenu :
- Agents Claude → `#agents` · `#claude`
- Sécurité / VM → `#securite` · `#infrastructure`
- Workflow / commandes → `#workflow` · `#tooling`
- Accessibilité → `#accessibilite`
- Linear / DataPass → `#datapass`

### 4. Nettoyer `.claude/plans/`

Après copie réussie → supprimer le fichier original de `.claude/plans/`.

### 5. Commit + push vault

```bash
cd "$VAULT"
git add "{Dossier}/"
git commit -m "archive: {type} — {titre slugifié}"
git pull --rebase && git push
```

Si `git pull --rebase` échoue → stop et signaler à Isabelle.

### 6. Confirmer

```
✅ Archivé + vault pushé

📁 note_datapass/{Dossier}/YYYY-MM-DD-{titre}.md
🏷 Tags : #tag1 #tag2
🔗 Commit vault : {sha} pushé sur origin/main
```

---

## Mode `--stale` (batch)

Rituel de nettoyage périodique (vendredi via `/weekly`, ou manuel quand `.claude/plans/`
est saturé). **Pas d'index Obsidian riche** — `mv` direct vers les destinations routées.
Les fichiers déposés en mode `--stale` servent de backup historique consultable via
`grep` ou recherche full-text Obsidian, pas via wikilinks/tags.

### 1. Scan des candidats

Lister tous les fichiers/dossiers dans `.claude/plans/` avec `mtime > 14 jours`.

**Skip systématique** :
- `_plan-session.md`, `_ship-session.md`, `_*-session.md` (sessions actives)
- Fichiers avec frontmatter `status: en cours` ou `status: draft` non terminé
- `PLAN_*.md` modifié dans les 14 derniers jours

**Skip conditionnel (mode ticket)** : pour chaque dossier `{KEY}-XXXX/` détecté,
appeler MCP Linear (`get_issue {KEY}-XXXX`). Si statut `Todo` ou `In Progress` → **skip**
(le contexte est encore utile à Isabelle).

### 2. Catégorisation

Router chaque candidat selon le pattern :

| Pattern | Destination |
|---------|-------------|
| Dossier `DP-XXXX*` ou `dp-XXXX*` | `Tickets/YYYY-MM/DP-XXXX/` (mois du dernier mtime) |
| Dossier `API-XXXX*` ou `api-XXXX*` | `Tickets/YYYY-MM/API-XXXX/` |
| Dossier `*cycle*` | `Suivi/cycles/{nom-original}-archive-YYYY-MM-DD/` |
| Dossier nommé `redaction_doc`, `documentation*` | `Documentation/{nom-slugifié}-YYYY-MM-DD/` |
| Fichier `review-*.md` | `Suivi/YYYY-MM-DD-{nom-original-sans-ext}.md` |
| Fichier `PLAN_*.md` | `Recherche/YYYY-MM-DD-{nom-original-sans-ext}.md` |
| Fichier `CONTEXTE_*.md` | `Recherche/YYYY-MM-DD-{nom-original-sans-ext}.md` |
| Fichier `rapport-*.md` | `Documentation/YYYY-MM-DD-{nom-original-sans-ext}.md` |
| Fichier `PROPOSITION_*.md` | `Suivi/YYYY-MM-DD-{nom-original-sans-ext}.md` |
| Autre (pattern inconnu) | listé dans la sortie, **non archivé** (demander à Isabelle) |

La date `YYYY-MM-DD` correspond au `mtime` du fichier/dossier source, pas à la date du jour.

### 3. Présenter le plan

Afficher un résumé groupé :

```
🗂 Cleanup --stale : 17 candidats détectés (.claude/plans/ → vault)

Suivi/ (11 reviews)
  review-pr-1493-admin-change.md         → Suivi/2026-04-13-review-pr-1493-admin-change.md
  review-pr-1497-tarification-eaje.md    → Suivi/2026-04-13-review-pr-1497-tarification-eaje.md
  ...

Tickets/2026-04/ (2 dossiers)
  DP-1649-API-Part-Aiden-MDGIS/          → Tickets/2026-04/DP-1649-API-Part-Aiden-MDGIS/
  api-6576-retirer-donnees-rbe/          → Tickets/2026-04/API-6576-retirer-donnees-rbe/

Recherche/ (5 plans)
  PLAN_accessibility-audit-skill.md      → Recherche/2026-04-20-PLAN_accessibility-audit-skill.md
  ...

Skippés (3) :
  DP-1392/         — ticket Todo dans Linear, contexte conservé
  _plan-session.md — session active
  PLAN_simplification-setup-claude-2026-05-18.md — modifié hier, status: en cours

Procéder à l'archivage ? (oui / non)
```

Si `--yes` est passé en argument : skip la confirmation, archive directement.

### 4. Archiver en batch

```bash
VAULT="/Users/isalafont/code/BetaGouv/note_datapass"
PLANS="/Users/isalafont/code/BetaGouv/Etalab/data_pass/.claude/plans"

# Pour chaque candidat :
mkdir -p "$VAULT/{dest-folder}"
mv "$PLANS/{source}" "$VAULT/{dest-folder}/{nom-final}"
```

**Pas d'index Obsidian créé**, pas de frontmatter ajouté, pas de MAJ de la note epic,
pas de scan des daily logs. Juste un `mv` propre vers la destination routée.

Si un dossier source contient des sous-dossiers (cas du dossier ticket avec arborescence),
préserver l'arborescence telle quelle.

### 5. Commit + push vault

```bash
cd "$VAULT"
git add Suivi/ Tickets/ Recherche/ Documentation/
git commit -m "cleanup: stale plans archive YYYY-MM-DD ({N} items)"
git pull --rebase && git push
```

Le commit groupe tous les items archivés en un seul commit. Si `git pull --rebase`
échoue (conflit avec un autre poste) → stop et signaler à Isabelle, ne pas push.

### 6. Confirmer

```
✅ Cleanup --stale terminé + vault pushé

📦 17 items archivés vers le vault
   Suivi/ : 11 reviews
   Tickets/2026-04/ : 2 dossiers tickets
   Recherche/ : 5 plans

⚠️ Skippés : DP-1392/ (Todo Linear), _plan-session.md (actif), PLAN_simplification-… (en cours)

🔗 Commit vault : {sha} pushé sur origin/main
```

---

## Règles (tous modes)

- ✅ Toujours afficher l'inventaire et confirmer avant de déplacer (sauf `--stale --yes`)
- ✅ Ne pas supprimer avant copie réussie vérifiée
- ✅ Slugifier les noms de fichiers générés (minuscules, tirets, sans accents)
- ✅ **Après archivage, toujours commit + `git pull --rebase` + push le vault** (tous modes — mono-poste avec divergence possible si modifs côté Obsidian iOS / iPad / autre laptop)
- ✅ Si `git pull --rebase` échoue (conflit) : stop, ne pas push, signaler à Isabelle pour résolution manuelle
- ❌ Ne pas modifier les daily logs existants
- ❌ Ne pas supprimer les fichiers `_*-session.md` (tous modes)
- ❌ Mode `--stale` : ne jamais archiver un ticket dont le statut Linear est `Todo` ou `In Progress`
- ❌ Pas de `--force` push, jamais
