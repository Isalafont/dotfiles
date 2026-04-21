# Handover

## Rôle

Synthétise cette session en un snapshot de passation factuel et actionnable. Priorité à ce qui est non-évident : décisions structurantes, gotchas rencontrés, blocages résolus. Pas les détails mécaniques.

---

## 🎯 Quand utiliser cette commande

En **fin de session** (ou quand le contexte se remplit) pour générer un snapshot complet de passation — afin que la prochaine instance Claude reprenne exactement là où on s'est arrêté.

Différence avec `/recap` :
- `/recap` = fichier vivant, multi-sessions, orienté projet long terme
- `/handover` = snapshot de passation, orienté transmission immédiate entre sessions

---

## 📋 Usage

```bash
/handover                    # Génère .claude/plans/HANDOVER_{YYYY-MM-DD}.md
/handover DP-1551            # Génère .claude/plans/HANDOVER_DP-1551_{YYYY-MM-DD}.md
```

---

## 🔄 Instructions

### 1. Déterminer le nom du fichier

**Si argument (ex: `DP-1551`) :**
- Créer `.claude/plans/HANDOVER_{argument}_{YYYY-MM-DD}.md`

**Si pas d'argument :**
- Créer `.claude/plans/HANDOVER_{YYYY-MM-DD}.md`

---

### 2. Parcourir l'historique de la session

**Avant d'écrire, identifie ce qui était vraiment important dans cette session : décisions non-évidentes, gotchas, blocages résolus. Écarte les détails mécaniques.**

Extraire :
- Ce qui était en cours au début
- Ce qui a été fait, étape par étape
- Ce qui n'a pas marché et comment c'a été résolu
- Les décisions prises et leur justification
- Les fichiers touchés

---

### 3. Générer le fichier

Structure obligatoire :

```markdown
# HANDOVER — Session du {YYYY-MM-DD}

> Généré en fin de session. À lire par la prochaine instance Claude pour reprendre sans perte de contexte.

---

## 🎯 Ce qu'on faisait

[Contexte général de la session — objectif principal et tickets concernés]

---

## ✅ Ce qui a été fait

- [Action concrète 1]
- [Action concrète 2]
- [...]

---

## 🔑 Décisions prises

### [Décision 1]

**Décision :** [Ce qui a été décidé]
**Justification :**
- [Raison 1]
- [Raison 2]

[Autant de sections que nécessaire]

---

## ⚠️ Gotchas & Leçons apprises

- [Piège rencontré — comment l'éviter]
- [Comportement surprenant découvert]
- [Contrainte technique à ne pas oublier]

---

## 🗂️ Fichiers clés

| Fichier | Rôle |
|---------|------|
| `chemin/vers/fichier` | [Ce qu'il fait dans ce contexte] |

---

## 🚀 Prochaines étapes

1. [Action prioritaire — la plus immédiate]
2. [Action suivante]
3. [...]

---

## 📌 État des tickets en cours

- **DP-XXXX** : [État actuel et ce qui reste]
- **[branche]** : [État de la branche]
```

### 4. Mettre à jour le daily log (conditionnel)

Lire `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` (date du jour).

**Si la section "Réalisations du Jour" est remplie (non vide, non placeholder) :**
→ `/evening` a déjà tourné. Ne jamais modifier "Réalisations du Jour".
→ Mais **ajouter quand même** dans "Notes de Travail" si du travail a eu lieu après /evening.

**Si "Réalisations du Jour" est vide/placeholder :**
→ `/evening` n'a pas encore tourné → ajouter dans "Notes de Travail".

Dans les deux cas, ajouter dans la section "Notes de Travail" :

```markdown
### Handover — {contexte de la session}

**Tickets en cours :** {liste des tickets de la session}
**Étape suivante :** {la prochaine action prioritaire}
**Fichier handover :** `.claude/plans/{nom du fichier généré}`
```

Si le daily log n'existe pas : créer le fichier avec la structure minimale
(date + section "Notes de Travail") avant d'y écrire.

---

## ⚠️ Règles

- ✅ Toujours générer dans `.claude/plans/`, jamais à la racine du projet
- ✅ Être factuel : ce qui a été fait, pas ce qui était prévu
- ✅ Gotchas = pièges concrets rencontrés dans cette session
- ✅ Prochaines étapes = actions immédiates, pas une roadmap générale
- ❌ Ne pas dupliquer ce qui est déjà dans un fichier CONTEXTE existant — faire référence à ce fichier
- ❌ Ne pas résumer la conversation mot à mot — extraire l'essentiel

---

## 🔗 Commandes liées

- `/recap` — Mettre à jour un fichier contexte de projet long terme
- `/plan` — Créer un plan technique pour un ticket
- `/morning` — Démarrer la journée avec contexte chargé
- `/evening` — Terminer la journée et clôturer le suivi

---

## 💡 Convention de nommage

```
.claude/plans/HANDOVER_{YYYY-MM-DD}.md
.claude/plans/HANDOVER_{topic-ou-ticket}_{YYYY-MM-DD}.md
```

Exemples :
- `HANDOVER_2026-02-23.md`
- `HANDOVER_DP-1551_2026-02-23.md`
- `HANDOVER_outillage_2026-02-23.md`

---
