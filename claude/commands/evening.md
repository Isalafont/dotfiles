# Evening

## 🎯 Quand utiliser cette commande

En **fin de journée** pour clôturer le daily log, résumer le travail accompli
et préparer les priorités du lendemain.

---

## 📋 Usage

```bash
/evening
```

---

## 🔄 Instructions

### 1. Analyser la session du jour

Parcourir l'historique de la conversation pour extraire :
- Les tickets travaillés (avec ID Linear)
- Ce qui a été accompli (commits, PRs, décisions)
- Les blocages rencontrés
- Les leçons apprises

### 2. Lire le daily log du jour

Lire `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` (date du jour).
S'il n'existe pas (morning non lancé) : le créer avec la structure complète.
S'il existe : compléter sans écraser les sections déjà remplies par /handover ou /recap.

### 3. Mettre à jour les sections de tickets dans le daily log

**Déplacer les tickets selon leur statut final :**
- PR ouverte → déplacer vers `👀 En review`
- Ticket complété / mergé → déplacer vers `✅ Done`
- Ticket démarré aujourd'hui → ajouter dans `🔄 En cours` avec ses tags

**Ajouter les tags Obsidian manquants** sur les nouvelles entrées de tickets.

### 4. Compléter les sections de clôture

**Section "📝 Notes de Travail"** — pour chaque ticket travaillé :

```markdown
### [[DP-XXXX]] : {Titre du ticket} #{tag}

**Statut** : {🔄 In Progress / ✅ Complété / 👀 En Review}
**Branche** : `{nom-de-branche}`

**Travail réalisé** :
- {Action 1}
- {Action 2}

**Leçons apprises** :
- {Si applicable}

---
```

**Section "🏆 Réalisations du Jour"** (marqueur de clôture — doit être remplie) :

```markdown
- ✅ {Réalisation 1}
- ✅ {Réalisation 2}
```

**Section "🎫 Tickets Travaillés"** :

```markdown
**[[DP-XXXX]]** - {Titre} ({statut})
- Temps passé : {estimation}
- Commits : {si applicable}
```

**Section "🌅 Préparation du Lendemain"** :

```markdown
**Priorités** :
1. {Priorité 1}
2. {Priorité 2}
```

### 4. Mettre à jour les notes de tickets (seulement si tickets travaillés)

Pour chaque ticket Linear travaillé aujourd'hui :

**4a. Ajouter une ligne dans la section "Sessions de travail" du ticket**

Chercher la note du ticket dans le vault :
- `Tickets/DP-XXXX.md` (note plate)
- `Tickets/YYYY-MM/DP-XXXX/index.md` (sous-dossier)

Si la section `## 📅 Sessions de travail` existe et contient un tableau, ajouter une ligne :
```
| [[YYYY-MM-DD]] | {Résumé en une ligne de ce qui a été fait} |
```
Si la section est en liste à puces (ancien format), convertir en tableau puis ajouter.
Si la note de ticket n'existe pas encore : ne rien faire.

**4b. Mettre à jour la note epic (si le ticket a un champ `epic` dans son frontmatter)**

Chercher la note epic dans `Epics/{epic-id}.md`.
Si elle existe :
- Dans le tableau "Sous-tickets", mettre à jour le statut de la ligne correspondante
- Dans la section "Sessions de travail" de l'epic, ajouter la date si elle n'y figure pas déjà :
```
| [[YYYY-MM-DD]] | [[DP-XXXX]], [[DP-YYYY]] |
```

### 5. Mettre à jour tickets.md (seulement si tickets travaillés)

Si aucun ticket Linear travaillé aujourd'hui : **ne pas toucher au fichier**.

Si des tickets ont été travaillés :
- Lire `/Users/isalafont/code/BetaGouv/note_datapass/Suivi/tickets.md` — c'est un **template de référence**, ne jamais le modifier
- Utiliser sa structure comme modèle pour ajouter les entrées réelles dans les bonnes sections
- Déplacer les tickets terminés vers "Terminés (Récents)"
- Mettre à jour le statut des tickets en cours
- Ajouter les nouvelles infos (PR, blocages, décisions)
- Mettre à jour la date en bas du fichier (`*Dernière mise à jour : YYYY-MM-DD*`)

### 6. Résumer à Isabelle

Afficher :
- Tickets travaillés et leur statut final
- Réalisations clés du jour
- Priorités du lendemain

---

## ⚠️ Règles

- ✅ Toujours remplir "Réalisations du Jour" — c'est le marqueur de clôture utilisé par /handover et /recap
- ✅ Toujours mettre à jour tickets.md
- ✅ Être factuel — ce qui a été fait, pas ce qui était prévu
- ✅ Référencer les IDs Linear dans chaque entrée
- ❌ Ne pas réécrire les sections déjà remplies par /handover ou /recap dans les Notes de Travail
- ❌ Ne pas modifier les logs des jours précédents

---

## 🔗 Commandes liées

- `/morning` — Démarrer la journée avec contexte chargé
- `/weekly` — Rapport hebdomadaire (agrège les daily logs)
- `/handover` — Snapshot de passation entre sessions