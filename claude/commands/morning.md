# Morning

## 🎯 Quand utiliser cette commande

En **début de session** pour charger le contexte de la veille, créer le daily log
et identifier les priorités du jour.

---

## 📋 Usage

```bash
/morning
```

---

## 🔄 Instructions

### 1. Lire le dernier daily log

Chercher le fichier le plus récent dans `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/`.
Extraire :
- Les tickets en cours
- Les priorités identifiées (section "Préparation du Lendemain")
- Les blocages éventuels

### 2. Fetcher les tickets Linear assignés

Via MCP Linear, récupérer les issues assignées à Isabelle
(user ID `733836f2-a572-4acd-bd62-b70ce08c6421`)
dans l'équipe DataPass (ID `41f8feef-8341-44b0-9dc8-bd2cd44e514f`).
Filtrer : statuts In Progress + Todo, triés par priorité.

### 3. Évaluer si un contexte suffisant existe

**Contexte suffisant** si au moins l'une de ces conditions est vraie :
- Des tickets Linear In Progress sont assignés
- Le dernier log contient des priorités pour aujourd'hui
- Un fichier HANDOVER ou CONTEXTE récent existe dans `.claude/plans/`

**Si contexte insuffisant** (tout vide / tout terminé / aucun ticket assigné) :
Poser une ou deux questions pour orienter la journée :
- « Sur quel ticket ou sujet veux-tu travailler aujourd'hui ? »
- « Y a-t-il un contexte particulier à charger ? »

### 4. Créer le daily log du jour

Si le fichier `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` n'existe pas encore, le créer.

**Pour chaque ticket en cours**, lire sa note dans le vault (`Tickets/DP-XXXX.md` ou `Tickets/YYYY-MM/DP-XXXX/index.md`) et récupérer le champ `epic` du frontmatter. S'il est renseigné, ajouter `(epic: [[{epic-id}]])` après le titre dans la liste des tickets du daily log.

**Déterminer les tags Obsidian** depuis les tickets en cours :
- Features actives → `#types-habilitation`, `#upload`, `#accessibilite`…
- Domaines → `#admin-ui`, `#formulaire`, `#data-provider`, `#audit-rgaa`…
- Types → `#test-coverage`, `#bug`, `#refacto`…
- Si jeudi après-midi : ajouter `#audit-rgaa`

```markdown
---
date: YYYY-MM-DD
day: {Jour}
tickets: [DP-XXXX, DP-XXXX]
tags: [tag-feature, tag-domaine]
---

# YYYY-MM-DD - {Jour de la semaine}
#{tag-feature} #{tag-domaine}

## 📥 Contexte de la veille

> Repris depuis le log du {date précédente}

{Priorités identifiées la veille — ou "Aucun log précédent trouvé"}

## 🎯 Tickets du jour

### 🔄 En cours

- **[[DP-XXXX]]** — {Titre} (epic: [[DP-XXXX-epic]]) #{tag-feature} #{tag-domaine}

### 👀 En review

- **[[DP-XXXX]]** — {Titre} #{tag-feature}

### 📋 À traiter

- **[[DP-XXXX]]** — {Titre} #{tag-feature}

### ✅ Done

{Tickets terminés dans la journée}

## 📝 Notes de Travail

{Sections ajoutées au fil de la journée par /handover, /recap ou /evening}

## 🏆 Réalisations du Jour

{À compléter en fin de journée via /evening}

## 🎫 Tickets Travaillés

{À compléter en fin de journée via /evening}

## 🌅 Préparation du Lendemain

{À compléter en fin de journée via /evening}
```

**Taxonomie de tags validée :**
- Features : `#types-habilitation` · `#upload` · `#accessibilite`
- Domaines : `#admin-ui` · `#formulaire` · `#data-provider` · `#audit-rgaa`
- Types : `#test-coverage` · `#bug` · `#refacto`

**Sections à omettre si vides** : ne pas inclure "👀 En review" ou "✅ Done" si aucun ticket dans ce statut au matin.

Si le fichier existe déjà (morning lancé deux fois dans la journée) :
ne pas l'écraser, juste afficher le résumé.

### 5. Afficher le résumé à Isabelle

Présenter clairement :
- Ce qui était en cours hier (ou "Nouveau départ" si rien)
- Les tickets prioritaires du jour (Linear)
- L'emplacement du daily log

---

## ⚠️ Règles

- ✅ Créer le daily log même si aucun log de la veille n'existe
- ✅ Indiquer clairement quand aucun ticket prioritaire n'est identifié
- ✅ Poser des questions uniquement si le contexte est vraiment insuffisant
- ❌ Ne pas modifier les logs des jours précédents
- ❌ Ne pas écraser un daily log déjà créé dans la journée

---

## 🔗 Commandes liées

- `/evening` — Terminer la journée et clôturer le suivi
- `/handover` — Snapshot de passation entre sessions
- `/weekly` — Rapport hebdomadaire