---
name: retro
description: Rétrospective de sprint — analyse les patterns de travail sur une période (Obsidian + Linear + git) pour identifier friction, progrès et actions concrètes
argument-hint: [période: "semaine" | "sprint" | "YYYY-MM-DD:YYYY-MM-DD"]
allowed-tools: Read, Glob, Grep, Bash, mcp__linear-server__list_issues, mcp__linear-server__get_issue
---

# Rétro

Analyse les patterns de travail sur une période pour produire une rétrospective actionnable.

## Quand Utiliser

- En fin de sprint ou de semaine
- Quand on veut identifier des patterns récurrents (types de bugs, points de friction)
- Pour préparer une vraie rétrospective d'équipe avec des données concrètes

## Arguments

- **Pas d'argument** → période = semaine courante (lundi → aujourd'hui)
- **`semaine`** → idem
- **`sprint`** → 2 dernières semaines
- **`YYYY-MM-DD:YYYY-MM-DD`** → période personnalisée

## Workflow

### Étape 1 — Déterminer la période

Calculer les dates de début et fin selon l'argument.
Date du jour disponible dans le contexte système (`currentDate`).

### Étape 2 — Collecter les données

#### 2a. Daily logs Obsidian

Lire les fichiers `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` pour chaque jour de la période.

Extraire :
- Tickets travaillés (section "Tickets Travaillés")
- Réalisations (section "Réalisations du Jour")
- Notes de travail (points de friction, blocages mentionnés)

#### 2b. Linear — tickets fermés sur la période

Via MCP Linear, lister les issues de l'équipe DataPass (`41f8feef-8341-44b0-9dc8-bd2cd44e514f`) assignées à Isabelle (`733836f2-a572-4acd-bd62-b70ce08c6421`) avec statut Done/Cancelled sur la période.

#### 2c. Git — activité de la branche

```bash
git log --oneline --since="YYYY-MM-DD" --until="YYYY-MM-DD" --author="Isabelle"
git branch -a | grep -v HEAD  # branches créées/actives
```

Identifier :
- Nombre de commits
- Branches abandonnées (créées mais non mergées)
- Rebases / conflits dans les messages de commit

### Étape 3 — Analyser les patterns

Pour chaque ticket travaillé, identifier :
- **Type** : bug / feature / refactor / chore / a11y
- **Durée estimée vs réelle** (si disponible dans Linear)
- **Points de friction** : mentionnés dans les notes, rebase, flaky tests, GPG...
- **Blocages** : tickets en pause, worktrees abandonnés

Calculer :
- Ratio bug/feature sur la période
- Temps moyen par type de ticket
- Récurrence de certains types de problèmes

### Étape 4 — Produire le rapport

```markdown
# Rétro — {période}

## ✅ Ce qui a bien marché
[Ce qui s'est passé sans friction, livraisons réussies, bonnes décisions]

## ⚠️ Points de friction
[Blocages rencontrés, outils défaillants, processus lourds]

## 🔁 Patterns récurrents
[Types de problèmes qui reviennent, ex: "3 rebases cette semaine", "2 flaky tests bloquants"]

## 📊 Vélocité
- Tickets fermés : X
- Répartition : X bug / X feature / X chore
- PRs mergées : X

## 🎯 3 actions pour le prochain sprint
1. [Action concrète et mesurable]
2. [Action concrète et mesurable]
3. [Action concrète et mesurable]
```

### Étape 5 — Sauvegarder

Écrire le rapport dans :
```
/Users/isalafont/code/BetaGouv/note_datapass/Journal/Reports/Weekly/RETRO_{YYYY-MM-DD}.md
```

Et ajouter une entrée dans le daily log du jour :
```markdown
### Rétro — {période}
Rapport : `Journal/Reports/Weekly/RETRO_{YYYY-MM-DD}.md`
```

## Règles

- Ne pas inventer de données — si un daily log manque, l'indiquer
- Les actions doivent être concrètes et vérifiables au prochain sprint
- Pas de jugement — c'est un outil de progression, pas d'évaluation
- Croiser les données Obsidian ET Linear : l'un sans l'autre donne une image incomplète