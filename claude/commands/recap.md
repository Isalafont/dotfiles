# Recap

## Rôle

Capture ou met à jour un fichier contexte de projet long terme. Synthétise ce qui a changé — décisions, état, prochaines étapes — sans réécrire l'historique existant.

---

## 🎯 Quand utiliser cette commande

En **fin de session** pour capturer ce qui a été fait, les décisions prises et ce qui reste à faire — afin de pouvoir reprendre efficacement plus tard.

---

## 📋 Usage

```bash
/recap                          # Mettre à jour le fichier contexte existant
/recap amelioration-commandes   # Créer un nouveau fichier CONTEXTE_{topic}_{date}.md
/recap .claude/plans/CONTEXTE_xxx.md  # Mettre à jour un fichier spécifique
```

---

## 🔄 Instructions

### 1. Déterminer le mode

**Si argument = nom de topic (ex: `amelioration-commandes`) :**
- Créer `.claude/plans/CONTEXTE_{topic}_{YYYY-MM-DD}.md`
- Mode : création

**Si argument = chemin de fichier existant :**
- Lire le fichier
- Mode : mise à jour

**Si pas d'argument :**
- Chercher les fichiers `CONTEXTE_*.md` dans `.claude/plans/`
- S'il y en a un seul : le mettre à jour
- S'il y en a plusieurs : demander lequel mettre à jour
- S'il n'y en a pas : demander un nom de topic pour en créer un

---

### 2. Mode CRÉATION

Créer le fichier avec cette structure :

```markdown
# Contexte : Session du {YYYY-MM-DD} - {Description courte}

## 🎯 Question initiale

**Problème identifié :**
[Ce qui a motivé cette session]

**Question :**
[La question ou l'objectif initial]

## ✅ Décisions prises

### 1. [Décision principale]

**Décision :** [Ce qui a été décidé]
**Justification :**
- [Raison 1]
- [Raison 2]

[Autant de sections que nécessaire]

## 📋 Plan d'implémentation

### Phase 1 : [Nom]
- ✅ [Tâche faite]
- ⏳ [Tâche à faire]

[Autant de phases que nécessaire]

## 📊 État actuel (fin de session {YYYY-MM-DD})

### ✅ Terminé
- [Ce qui est fait]

### 🔧 En cours
- [Ce qui est en cours] (ou "Rien")

### ⏳ À faire
- [Ce qui reste]

## ⚠️ Gotchas & Leçons apprises

- [Piège ou erreur rencontré — comment l'éviter]
- [Comportement surprenant découvert]
- [Contrainte technique à ne pas oublier]

## 🗂️ Fichiers clés

| Fichier | Rôle |
|---------|------|
| `chemin/vers/fichier` | [Ce qu'il fait dans ce contexte] |

## 🎯 Prochaines étapes

1. [Action prioritaire]
2. [Action suivante]

## 📝 Changelog

**{YYYY-MM-DD} :**
- [Ce qui a été fait aujourd'hui]
```

**Avant d'écrire**, infère le contexte depuis la conversation si elle est suffisamment riche. Si des informations manquent, pose les questions nécessaires (une à la fois) :
- Quel est le contexte/problème initial ?
- Quelles décisions importantes ont été prises ?
- Y a-t-il un plan d'implémentation avec des phases ?

---

### 3. Mode MISE À JOUR

**Relis le fichier existant et l'historique de la session — identifie ce qui a réellement changé avant d'écrire.**

Puis :

1. **Mettre à jour les statuts** dans le plan d'implémentation :
   - `⏳` → `✅` pour ce qui a été fait aujourd'hui
   - Ajouter les nouvelles tâches découvertes

2. **Ajouter une entrée dans le Changelog** :
   ```markdown
   **{YYYY-MM-DD} :**
   - ✅ [Ce qui a été fait]
   - ✅ [Autre chose faite]
   ```

3. **Mettre à jour "État actuel"** :
   - Déplacer les items terminés de ⏳ vers ✅
   - Mettre à jour "En cours" et "À faire"

4. **Mettre à jour "Prochaines étapes"** si nécessaire

5. **Enrichir "Gotchas & Leçons apprises"** si quelque chose de nouveau a été découvert :
   - Piège rencontré et comment l'éviter
   - Comportement surprenant
   - Ne pas dupliquer ce qui est déjà dans MEMORY.md

6. **Mettre à jour "Fichiers clés"** si de nouveaux fichiers importants ont été manipulés

7. **Mettre à jour le daily log (conditionnel)**

   Lire `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` (date du jour).

   **Si la section "Réalisations du Jour" est remplie :**
   → `/evening` a déjà tourné. Ne jamais modifier "Réalisations du Jour".
   → Mais **ajouter quand même** dans "Notes de Travail" si du travail a eu lieu après /evening.

   **Si "Réalisations du Jour" est vide/placeholder :**
   → `/evening` n'a pas encore tourné → ajouter dans "Notes de Travail".

   Dans les deux cas, ajouter dans la section "Notes de Travail" :

   ```markdown
   ### Recap — {topic}

   **Décisions prises :** {résumé des décisions clés}
   **Fichier contexte :** `.claude/plans/CONTEXTE_{topic}_{date}.md`
   ```

   Si le daily log n'existe pas : créer le fichier avec la structure minimale
   (date + section "Notes de Travail") avant d'y écrire.

**Ne pas réécrire tout le fichier** — mettre à jour uniquement les sections concernées.

---

## ⚠️ Règles

- ✅ Toujours ajouter une entrée datée dans le Changelog
- ✅ Mettre à jour les statuts (⏳/✅) dans le plan
- ✅ Garder le fichier lisible — supprimer ce qui est obsolète
- ❌ Ne pas réécrire l'historique des sessions précédentes
- ❌ Ne pas créer de doublon si un fichier contexte existe déjà pour ce topic

---

## 🔗 Commandes liées

- `/plan` — Créer un plan technique pour un ticket
- `/ship` — Workflow complet ticket → PR
- `/morning` — Démarrer la journée avec contexte chargé
- `/evening` — Terminer la journée et clôturer le suivi

---

## 💡 Convention de nommage

```
.claude/plans/CONTEXTE_{topic}_{YYYY-MM-DD}.md
```

Exemples :
- `CONTEXTE_amelioration-commandes_2026-02-18.md`
- `CONTEXTE_migration-obsidian_2026-02-20.md`
- `CONTEXTE_refonte-auth_2026-03-01.md`

---
