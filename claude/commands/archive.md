# Archive → Vault Obsidian

Archive les fichiers de `.claude/plans/` vers le vault Obsidian DataPass.
Gère deux cas : ticket Linear terminé, ou plan/recherche hors ticket.

## Usage

```
/archive DP-1234                     # ticket Linear
/archive                             # ticket de la session en cours
/archive PLAN_claude-agents.md       # plan de recherche hors ticket
/archive rapport-secu-vm.md          # rapport technique
/archive PROPOSITION_workflow.md     # proposition / réflexion
```

---

## Détection du mode

- Argument correspond à `DP-\d+` (ex: `DP-1234`, `dp-1234`) → **mode ticket**
- Argument est un nom de fichier ou absent avec `_plan-session.md` pointant vers un ticket → **mode ticket**
- Argument est un nom de fichier sans ID Linear → **mode recherche**
- Aucun argument et session sans ticket Linear → demander : "Ticket ou plan de recherche ?"

---

## Mode ticket

### 1. Identifier le ticket

- Si argument fourni → normaliser en majuscules : `dp-1234` → `DP-1234`
- Sinon → lire `.claude/plans/_plan-session.md` ou `_ship-session.md` pour le ticket en cours
- Récupérer le titre et statut via MCP Linear (user `733836f2-a572-4acd-bd62-b70ce08c6421`)

### 2. Inventaire des fichiers

Chercher dans `.claude/plans/` :
- Dossier `DP-XXXX/` ou sous-dossier d'epic `{NOM-EPIC}/DP-XXXX/` → tout son contenu
- Fichiers plats `DP-XXXX-*.md` à la racine de `.claude/plans/`
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

### 7. Confirmer

```
✅ DP-XXXX archivé

📁 note_datapass/Tickets/YYYY-MM/DP-XXXX/
   index.md  ← note Obsidian avec tags + wikilinks
   plan.md
   context.md

🏷 Tags : #tag1 #tag2 #done
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

### 5. Confirmer

```
✅ Archivé

📁 note_datapass/{Dossier}/YYYY-MM-DD-{titre}.md
🏷 Tags : #tag1 #tag2
```

---

## Règles (tous modes)

- ✅ Toujours afficher l'inventaire et confirmer avant de déplacer
- ✅ Ne pas supprimer avant copie réussie vérifiée
- ✅ Slugifier les noms de fichiers générés (minuscules, tirets, sans accents)
- ❌ Ne pas modifier les daily logs existants
- ❌ Ne pas supprimer les fichiers `_*-session.md` (mode ticket)
