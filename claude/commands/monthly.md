# Monthly

## 🎯 Quand utiliser cette commande

En **fin de mois** pour produire un bilan mensuel visuel avec statistiques agrégées,
tendances et apprentissages clés.

---

## 📋 Usage

```bash
/monthly          # Mois en cours
/monthly 2026-02  # Mois spécifique (YYYY-MM)
```

---

## 🔄 Instructions

### 1. Identifier les weekly reports du mois

Lire tous les fichiers `WEEK_{YYYY-WNN}.md` dans
`/Users/isalafont/code/BetaGouv/note_datapass/Journal/Reports/Weekly/`
dont les semaines appartiennent au mois cible.

**Pour chaque weekly manquant :**
Générer automatiquement le rapport depuis les daily logs correspondants
(même logique que `/weekly`) et le sauvegarder avant de continuer.
Noter dans le bilan : "⚠️ Semaine WNN reconstituée depuis les daily logs".

### 2. Agréger les statistiques

Sommer depuis les weekly reports :
- Total tickets complétés / en review / in progress
- Total PRs ouvertes / mergées
- Total commits
- Total jours travaillés / jours ouvrés du mois
- Temps total estimé

Calculer les moyennes :
- Tickets complétés / semaine
- Temps moyen par ticket
- Taux de présence (jours travaillés / jours ouvrés)

Lire le rapport du mois précédent (`MONTH_{YYYY-MM-1}.md`) pour extraire : tickets traités, complétés, PRs mergées, taux de présence — calculer les deltas (↑ / ↓ / =). Si absent, omettre la ligne comparaison.

### 3. Agréger le travail hors-ticket du mois

Depuis les sections "🔧 Travail hors-ticket" des weekly reports (ou, si absentes, depuis les daily logs), extraire et dédoublonner :
- Tooling / config Claude Code
- Refactorisations de processus
- Reviews de PR externes
- Documentation, vault Obsidian
- Autres

Regrouper par catégorie pour la section mensuelle.

### 4. Identifier les tendances

- Semaine la plus productive (+ de tickets complétés)
- Ticket le plus chronophage du mois
- **Agrégation par epics** : lire le champ `epic` des notes de tickets dans `Tickets/` pour chaque ticket mentionné dans le mois. Grouper les tickets par epic et calculer le nombre de tickets travaillés par epic.
- **Agrégation par tags Obsidian** : quelle feature a dominé ? (`#types-habilitation`, `#upload`…)
- Domaines les plus travaillés (`#admin-ui`, `#formulaire`, `#audit-rgaa`…)
- Leçons apprises récurrentes (mentionnées dans 2+ semaines)
- Blocages récurrents

### 5. Fetcher Linear pour l'état fin de mois

Via MCP Linear, récupérer les statuts actuels de tous les tickets mentionnés
(user ID `733836f2-a572-4acd-bd62-b70ce08c6421`, team `41f8feef-8341-44b0-9dc8-bd2cd44e514f`).

### 6. Générer le bilan mensuel

Créer `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Reports/Monthly/MONTH_{YYYY-MM}.md` :

````markdown
# Bilan — {Mois complet YYYY}

---

## 📊 Vue d'ensemble du mois

```mermaid
pie title Tickets — {Mois YYYY}
    "Complétés" : {N}
    "En Review" : {N}
    "In Progress" : {N}
```

```mermaid
xychart-beta
    title "Tickets complétés par semaine"
    x-axis [{liste semaines ex: "W10", "W11", "W12", "W13"}]
    y-axis "Tickets complétés" 0 --> {max+1}
    bar [{N}, {N}, {N}, {N}]
    line [{N}, {N}, {N}, {N}]
```

**Résumé :** {N} tickets traités · {N} complétés · {N} PRs mergées · {N}/{ouvrés} jours · {X}h · {X}h/ticket en moy.

**vs {mois précédent} :** tickets traités {N} ({↑↓=}{delta}) · complétés {N} ({↑↓=}{delta}) · PRs {N} ({↑↓=}{delta}) · présence {X}% ({↑↓=}{delta})

---

## 📈 Semaine par semaine

| Semaine | Dates | Présence | ✅ | 🔄 | 🚧 | PRs |
|---------|-------|----------|----|----|-----|-----|
| W{NN} | {lundi}→{vendredi} | {N}/5 | {N} | {N} | {N} | {N} |

**Semaine la plus productive :** W{NN} — {N} tickets complétés

---

## 🏆 Top réalisations du mois

{5-10 réalisations les plus significatives, sélectionnées depuis les weekly reports — tickets uniquement}

---

## 🔧 Travail hors-ticket du mois

{Agrégé et dédoublonné depuis les sections "Travail hors-ticket" des weekly reports, regroupé par catégorie}

---

## 🗂 Epics du mois

| Epic | Titre | Tickets travaillés | Complétés |
|------|-------|--------------------|-----------|
| [[DP-XXXX-epic]] | {Titre de l'epic} | {N} | {N} ✅ |
| — | *(tickets sans epic)* | {N} | {N} ✅ |

---

## 🎫 Tous les tickets du mois

| Ticket | Epic | Titre | Statut final | Semaine(s) | ⏱ |
|--------|------|-------|-------------|------------|---|
| DP-XXXX | [[DP-XXXX-epic]] | {titre} | ✅ Complété | W10-W11 | {X}h |
| DP-XXXX | — | {titre} | 🔄 En Review | W12 | {X}h |

---

## 💡 Apprentissages clés du mois

**Récurrents (2+ semaines) :**
- {Leçon mentionnée plusieurs fois}

**Nouveaux :**
- {Leçon apparue une seule fois mais importante}

---

## ⚠️ Blocages du mois

| Blocage | Semaine | Résolu ? |
|---------|---------|----------|
| {description} | W{NN} | ✅ Oui / ❌ Non |

---

## 🎯 Objectifs mois prochain

{Tickets Linear In Progress + Todo prioritaires assignés à Isabelle}

**Charge estimée :** 🟢 Légère / 🟡 Normale / 🔴 Lourde — {contexte : epics en cours, tickets complexes vs finition}

---

## 📋 Sources

| Semaine | Rapport | Source |
|---------|---------|--------|
| W{NN} | `WEEK_{YYYY-WNN}.md` | ✅ Généré en temps réel |
| W{NN} | `WEEK_{YYYY-WNN}.md` | ⚠️ Reconstruit depuis daily logs |
````

### 7. Résumer à Isabelle

Afficher les stats clés du mois (présence, tickets, tendance principale)
et l'emplacement du fichier généré.

---

## ⚠️ Règles

- ✅ Générer automatiquement les weekly manquants (sans demander)
- ✅ Signaler clairement les rapports reconstitués dans le bilan
- ✅ Fetcher Linear pour les statuts réels en fin de mois
- ✅ Créer le dossier `Reports/Monthly/` s'il n'existe pas
- ✅ Lire le rapport M-1 pour calculer les deltas (si absent, omettre la ligne comparaison)
- ✅ Agréger le travail hors-ticket depuis les sections weekly (ou les daily logs si weekly absents)
- ❌ Ne pas modifier les weekly reports ou daily logs existants

---

## 🔗 Commandes liées

- `/weekly` — Rapport hebdomadaire
- `/morning` — Démarrer la journée avec contexte chargé
- `/evening` — Terminer la journée et clôturer le suivi