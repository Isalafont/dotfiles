# Weekly

## 🎯 Quand utiliser cette commande

En **fin de semaine** (vendredi soir ou lundi matin) pour agréger les daily logs
de la semaine et produire un rapport visuel avec statistiques.

---

## 📋 Usage

```bash
/weekly          # Semaine en cours (lundi → aujourd'hui)
/weekly 2026-W10 # Semaine spécifique (numéro ISO)
```

---

## 🔄 Instructions

### 1. Identifier les daily logs de la semaine

Lire tous les fichiers `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md`
correspondant à la semaine cible (lundi → vendredi).
Noter les jours sans fichier (non travaillé).

### 2. Agréger les données depuis les logs

Pour chaque daily log existant, extraire :
- Section "🏆 Réalisations du Jour" → actions accomplies
- Section "🎫 Tickets Travaillés" → IDs + statuts + temps estimés
- Section "📝 Notes de Travail" → décisions et leçons apprises
- Mentions de commits, PRs, reviews dans le texte libre
- **Tags Obsidian** des tickets → agréger par feature (`#types-habilitation`, `#upload`…)

Pour chaque ticket mentionné, lire sa note dans le vault (`Tickets/DP-XXXX.md` ou `Tickets/YYYY-MM/DP-XXXX/index.md`) et récupérer le champ `epic` du frontmatter. Construire la table de correspondance ticket → epic pour la semaine.

### 3. Fetcher l'état actuel des tickets sur Linear

Via MCP Linear, récupérer le statut actuel de chaque ticket mentionné dans la semaine
(user ID `733836f2-a572-4acd-bd62-b70ce08c6421`, team `41f8feef-8341-44b0-9dc8-bd2cd44e514f`).

### 4. Calculer les statistiques

Agréger depuis les logs :
- Tickets : complétés / en review / in progress / démarrés dans la semaine
- Actions : commits, PRs ouvertes, PRs mergées, reviews
- Temps : total estimé, moyenne par ticket, ticket le plus chronophage
- Présence : jours avec log / 5

Lire le rapport de la semaine précédente (`WEEK_{YYYY-W(NN-1)}.md`) pour extraire : tickets traités, complétés, PRs mergées — calculer les deltas (↑ / ↓ / =).

### 5. Identifier le travail hors-ticket

Depuis les "Réalisations du Jour" et "Notes de Travail", extraire les actions qui ne sont pas rattachées à un ticket Linear :
- Tooling / config Claude Code (hooks, skills, commandes)
- Refactorisations ou améliorations de processus
- Reviews de PR externes (pas liées à un ticket assigné)
- Documentation, vault Obsidian
- Autres (onboarding, réunions, etc.)

Agréger en une liste courte pour la section "Travail hors-ticket".

### 6. Identifier les features dominantes de la semaine

Depuis les tags Obsidian des tickets travaillés, calculer :
- Quelle feature a été la plus travaillée (`#types-habilitation`, `#upload`…)
- Quel domaine a dominé (`#admin-ui`, `#formulaire`…)
- Si `#audit-rgaa` présent → mentionner les jours d'audit RGAA

### 7. Générer le rapport hebdomadaire

Créer `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Reports/Weekly/WEEK_{YYYY-WNN}.md` :

````markdown
# Semaine {WNN} — du {lundi DD/MM} au {vendredi DD/MM}

---

## 📊 Tickets de la semaine

```mermaid
pie title Tickets — Semaine W{NN}
    "Complétés" : {N}
    "En Review" : {N}
    "In Progress" : {N}
```

```mermaid
xychart-beta
    title "Tickets traités par jour"
    x-axis ["Lun", "Mar", "Mer", "Jeu", "Ven"]
    y-axis "Tickets" 0 --> {max+1}
    bar [{lun}, {mar}, {mer}, {jeu}, {ven}]
```

**Résumé :** {N} tickets traités · {N} complétés · {N} PRs · {N}/5 jours travaillés · {X}h estimées

**vs W{NN-1} :** tickets traités {N} ({↑↓=}{delta}) · complétés {N} ({↑↓=}{delta}) · PRs {N} ({↑↓=}{delta})

**Feature dominante :** `#{tag-feature}` — {N} tickets · **Domaine :** `#{tag-domaine}`

---

## 🗂 Epics travaillées cette semaine

| Epic | Titre | Tickets travaillés |
|------|-------|--------------------|
| [[DP-XXXX-epic]] | {Titre de l'epic} | [[DP-XXXX]], [[DP-XXXX]] |
| — | *(tickets sans epic)* | [[DP-XXXX]] |

---

## 🎫 Détail des tickets

| Ticket | Epic | Titre | Début semaine | Fin semaine | ⏱ |
|--------|------|-------|---------------|-------------|---|
| DP-XXXX | [[DP-XXXX-epic]] | {titre} | 🚧 In Progress | ✅ Complété | {X}h |
| DP-XXXX | — | {titre} | 🆕 Démarré | 🔄 En Review | {X}h |

**Ticket le plus chronophage :** DP-XXXX — {X}h

---

## 📅 Activité jour par jour

| Jour | Présent | Tickets | Réalisation principale |
|------|---------|---------|----------------------|
| Lundi | ✅ | DP-XXXX | {action principale} |
| Mardi | ✅ | DP-XXXX | {action principale} |
| Mercredi | ❌ | — | — |
| Jeudi | ✅ | DP-XXXX | {action principale} |
| Vendredi | ✅ | DP-XXXX | {action principale} |

---

## ✅ Réalisations de la semaine

{Liste agrégée et dédoublonnée depuis les "Réalisations du Jour" — tickets uniquement}

---

## 🔧 Travail hors-ticket

{Tooling, config, reviews externes, documentation, processus — ce qui ne rentre pas dans les stats tickets}

---

## 💡 Leçons apprises

{Agrégation des leçons de chaque daily log, sans doublons}

---

## ⚠️ Blocages

{Agrégation des blocages — préciser si résolu ou non}

---

## 🎯 Priorités semaine prochaine

{Tickets Linear In Progress + Todo assignés à Isabelle}

**Charge estimée :** 🟢 Légère / 🟡 Normale / 🔴 Lourde — {1-2 phrases : backlog court/long, sujets complexes ou de finition}
````

### 6. Résumer à Isabelle

Afficher les stats clés (présence, tickets, PRs) et l'emplacement du fichier généré.

---

## ⚠️ Règles

- ✅ Indiquer les jours sans log avec ❌ dans le tableau d'activité
- ✅ Dédoublonner les réalisations et leçons agrégées
- ✅ Fetcher Linear pour les vrais statuts actuels (pas seulement ceux des logs)
- ✅ Créer le dossier `Reports/Weekly/` s'il n'existe pas
- ✅ Lire le rapport W-1 pour calculer les deltas (si absent, omettre la ligne comparaison)
- ✅ Distinguer réalisations tickets vs travail hors-ticket
- ❌ Ne pas modifier les daily logs existants

---

## 🔗 Commandes liées

- `/morning` — Démarrer la journée avec contexte chargé
- `/evening` — Terminer la journée et clôturer le suivi
- `/monthly` — Bilan mensuel (agrège les weekly reports)