# Overview

## 🎯 Quand utiliser cette commande

Bird's eye view multi-projets. À lancer quand tu veux un état global rapide :
- Quoi de neuf sur tes projets ?
- Quelles PRs attendent ?
- Quels tickets Linear sont In Progress / In Review ?
- Daily log du jour fait ou pas ?

Différent de `/morning` : `/overview` est instantané et factuel, sans création de daily log ni questions.

---

## 📋 Usage

```bash
/overview
```

---

## 🔄 Instructions

### 1. Fetcher les PRs ouvertes sur DataPass

Exécuter en parallèle :

```bash
gh pr list --repo etalab/data_pass --author @me --json number,title,headRefName,isDraft,statusCheckRollup,reviewDecision
gh pr list --repo etalab/data_pass --label dependencies --json number,title,statusCheckRollup
```

Classifier en 3 buckets :
- **À toi** : PRs où tu es auteure, CI vert, prêtes à merger
- **En attente** : PRs auteure mais CI ko ou waiting review
- **Dependabot** : avec leur état CI (utile pour planifier les bumps groupés)

### 2. Fetcher les tickets Linear en cours

Via MCP Linear, lister les tickets assignés à Isabelle
(user ID `733836f2-a572-4acd-bd62-b70ce08c6421`) **sans filtre d'équipe**.

Filtrer sur les statuts : `In Progress`, `In Review`, `Todo`. Trier par priorité.

Présenter en 3 colonnes : In Review · In Progress · Todo.

### 3. Activité git récente (depuis hier)

Pour chaque worktree actif (lister via `git worktree list` depuis DataPass main) :

```bash
git log --since="1 day ago" --oneline --all
```

Ne mentionner que les worktrees où il y a eu de l'activité.

### 4. Daily log du jour

Vérifier `~/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` :
- Existe ? → afficher si livrable du jour défini, et s'il y a déjà des Notes de Travail
- N'existe pas ? → suggérer de lancer `/morning`

### 5. Vault — décisions en attente

Lister les fichiers récents (< 7 jours) dans `~/code/BetaGouv/note_datapass/Decisions/` ou `~/code/BetaGouv/note_datapass/Meta/PLAN-*.md` qui contiennent des `[ ]` non cochés. Signaler s'il y a des décisions ou plans en cours.

### 6. Afficher le résumé

Format compact, prêt à digérer en 30 secondes :

```markdown
# 📊 Overview — YYYY-MM-DD

## 🔀 PRs DataPass

**À toi** (N) : #1234 titre — CI ✅
**En attente** (N) : #1235 titre — CI ❌
**Dependabot** (N) : #1567 ✅ · #1568 ⚠️

## 📋 Linear

| In Review (N) | In Progress (N) | Todo (N) |
|---|---|---|
| DP-XXXX titre | DP-XXXX titre | DP-XXXX titre |

## 🔁 Git activité (depuis hier)

- `data_pass` (branche `xxx`) — N commits
- `dp-1392` — N commits

## 📅 Daily log

✅/❌ `YYYY-MM-DD.md` — {résumé livrable ou "à créer via /morning"}

## 📂 Plans / décisions en cours

- `Meta/PLAN-xxx.md` — N tâches non cochées
```

---

## ⚠️ Règles

- ✅ Calls Linear et `gh` en parallèle (BatchTool)
- ✅ Si MCP Linear ko, fallback sur "(Linear unavailable)"
- ❌ Ne pas créer de fichier — c'est une vue read-only
- ❌ Ne pas poser de questions — c'est une commande factuelle

---

## 🔗 Commandes liées

- `/morning` — initialise la journée (création daily log, contexte)
- `/weekly` — récap hebdomadaire structuré
- `/po-brief` — formaliser une décision visible dans `/overview`
