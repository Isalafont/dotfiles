---
name: create-linear-ticket
description: Create Linear ticket for DataPass following project standards with interactive wizard
argument-hint: [ticket-type]
allowed-tools: [Read, mcp__linear-server__*]
---

# Create Linear Ticket

Assistant interactif pour créer des tickets Linear conformes aux standards DataPass.

## Quand Utiliser

**✅ Utiliser quand :**
- Besoin de créer un nouveau ticket Linear
- Garantir respect des standards projet
- Aide à la rédaction structurée
- Feature, Bug, A11y, ou autre type

**❌ Ne PAS utiliser quand :**
- Ticket déjà créé (utiliser update)
- Duplication d'un ticket existant

## Template de Référence

Ce skill utilise le template standard DataPass :
**`.claude/templates/linear-ticket-template.md`**

## Workflow Interactif

### Étape 1 : Lire le Template

Lire `.claude/templates/linear-ticket-template.md` pour référence.

### Étape 2 : Poser les Questions

Je vais vous poser 10 questions pour créer un ticket de qualité :

#### Q1 : Type de Ticket

**Options :**
- `feature` : Nouvelle fonctionnalité
- `bug` : Correction de bug
- `refactor` : Refactoring code
- `a11y` : Accessibilité RGAA
- `docs` : Documentation
- `test` : Tests
- `chore` : Maintenance

**Question :** Quel type de ticket ?

---

#### Q2 : Titre (max 60 chars)

**Format :** `[TYPE] Description courte et claire`

**Exemples :**
- `[Feature] Ajouter export CSV des habilitations`
- `[Bug] Erreur 500 validation email avec accents`
- `[A11y] Améliorer contraste boutons DSFR`

**Question :** Quel est le titre du ticket ?

---

#### Q3 : Context (Pourquoi ?)

**À inclure :**
- Quel problème résout-il ?
- Quelle valeur apporte-t-il ?
- Quel est l'impact utilisateurs ?

**Question :** Expliquez le contexte et la valeur du ticket.

---

#### Q4 : Acceptance Criteria (3-5 items)

**Format de rédaction (façon Natalia Bertel) :**
- Critères présentés en **tableau** `| CA | Description | État |` (cf. Étape 3)
- Chaque critère mesurable et testable, idéalement en Gherkin :
  « Étant donné … quand … alors … »
- Lier chaque CA à une règle de gestion (RG) quand pertinent

**Exemples :**
- CA-1 : Étant donné que je suis sur la page liste, quand je clique sur « Exporter CSV », alors un fichier se télécharge (RG-1)
- CA-2 : Étant donné un export généré, quand je l'ouvre, alors il contient ID, date, demandeur, statut (RG-2)

**Question :** Quels sont les critères d'acceptation ? (listez 3 à 5)
Optionnel : des **règles de gestion** (RG) à formaliser à part ?

---

#### Q5 : Technical Notes

**À inclure :**
- Fichiers concernés
- Approche technique envisagée
- Considérations (perf, sécu, a11y)

**Question :** Notes techniques pour le développeur ?

---

#### Q6 : Related (Optionnel)

**À inclure :**
- Issues/PRs liés (Closes #XXX, Related to #YYY)
- Documentation pertinente
- Design/Maquettes

**Question :** Y a-t-il des tickets/docs liés ?

---

#### Q7 : Priority

**Options :**
- `high` : Bloquant, bug critique (< 2 jours)
- `medium` : Important, feature planifiée (< 1 semaine)
- `low` : Nice to have (Backlog)

**Question :** Quelle est la priorité ?

---

#### Q8 : Labels

**Domain (obligatoire) :**
- `backend` : Rails, API, BDD
- `frontend` : JS, React, UI
- `accessibility` : RGAA, DSFR
- `infrastructure` : CI/CD, config
- `documentation` : README, guides

**Type spécifique (optionnel) :**
- `security`, `performance`, `ux`, `api`, `database`

**Question :** Quels labels ? (domain + optionnels)

---

#### Q9 : Estimate (Optionnel)

**Points :**
- `1` : Très simple (< 2h)
- `2` : Simple (2-4h)
- `3` : Moyen (1 jour)
- `5` : Complexe (2-3 jours)
- `8` : Très complexe (1 semaine)
- `13` : Epic (> 1 semaine, à découper)

**Question :** Estimation en points ?

---

#### Q10 : Assignee (Optionnel)

**Format :** Email ou @mention Linear

**Question :** Assigner à quelqu'un ?

---

### Étape 3 : Formater le Ticket

Générer la description au **format tableau Natalia Bertel** :

```markdown
## 📋 Context

[Réponse Q3]

## Règles de gestion

| **RG** | **Description** | **État** |
| -- | -- | -- |
| RG-1 | [Règle 1, si fournie en Q4] | ✅ OK &#10;❌ KO |
| RG-2 | [Règle 2] | ✅ OK &#10;❌ KO |

## Critères d’acceptation

| **CA** | **Description** | **État + RG** |
| -- | -- | -- |
| CA-1 | [Critère 1 de Q4, idéalement en Gherkin] | ✅ OK &#10;❌ KO &#10;RG - 1 |
| CA-2 | [Critère 2] | ✅ OK &#10;❌ KO &#10;RG - 2 |
| CA-3 | [Critère 3] | ✅ OK &#10;❌ KO |

## 🔧 Technical Notes

[Réponse Q5]

## 🔗 Related

[Réponse Q6]
```

**Notes de format :**
- `&#10;` = saut de ligne dans une cellule de tableau Markdown.
- La colonne « État » garde `✅ OK` / `❌ KO` comme cases à cocher visuelles, à pointer en review.
- Omettre la section « Règles de gestion » si aucune RG n'a été fournie ; dans ce cas la 3ᵉ colonne des CA s'intitule juste « **État** ».
- Apostrophe typographique (’) et guillemets français (« ») dans tout le contenu.

### Étape 4 : Validation

Afficher le ticket formaté et demander confirmation :

```
📋 Aperçu du ticket :

Titre : [Réponse Q2]
Priority : [Réponse Q7]
Labels : [Réponse Q8]
Estimate : [Réponse Q9]

Description :
[Description formatée]

✅ Créer ce ticket ? (yes/no)
```

### Étape 4bis : Choix de l'équipe

Avant de créer, demander si pas déjà précisé :

```
Quelle équipe Linear ?
  1. DataPass (key DP)        — team 41f8feef-8341-44b0-9dc8-bd2cd44e514f
  2. API Parteprise (key API) — team 06f4c81a-3435-400e-a2a7-68807d6cc14b
```

Par défaut : DataPass (la majorité des tickets DataPass restent dans cette équipe).
Choisir API Parteprise pour les tickets liés au projet « Api Parteprise : Mise en conformité »
ou tout sujet API Entreprise / API Particulier.

### Étape 5 : Créer via Linear MCP

Si confirmation, créer le ticket via les outils MCP `linear-server` avec :
- `title` : [Réponse Q2]
- `teamId` : ID de l'équipe choisie à l'étape 4bis
- `description` : [Description formatée markdown]
- `priority` : selon mapping
- `labelIds` : selon labels choisis
- `estimate` : [points si fourni]
- `assigneeId` : [ID si fourni]

**Mapping Priority :**
- `high` → `1` (Urgent)
- `medium` → `2` (High) ou `3` (Medium)
- `low` → `4` (Low)

### Étape 6 : Confirmer

Afficher l'URL du ticket créé (l'`identifier` retourné par Linear donne le bon préfixe `DP-` ou `API-`) :

```
✅ Ticket créé avec succès !

🎫 {identifier} : [Titre]              # ex: DP-1234 ou API-6740
🔗 {url retourné par Linear}
```

## Exemples d'Utilisation

### Exemple 1 : Feature Complète

```
User: /create-linear-ticket

Claude: Je vais vous aider à créer un ticket Linear.

Q1 : Quel type de ticket ?
User: feature

Q2 : Titre du ticket (max 60 chars) ?
User: Ajouter export CSV des habilitations

Q3 : Context - Pourquoi ce ticket ?
User: Les instructeurs ont besoin d'exporter les habilitations pour leurs rapports mensuels. Gain de temps ~30min/mois pour ~20 instructeurs.

Q4 : Acceptance Criteria (3-5) ?
User:
- Bouton "Exporter CSV" visible sur page liste
- Export contient : ID, date, demandeur, API, statut
- Fichier nommé : habilitations_YYYY-MM-DD.csv
- Export filtré selon filtres actifs

Q5 : Technical Notes ?
User: Créer CsvExporterService, ajouter route GET /instructor/authorization_requests/export.csv, utiliser gem CSV standard

Q6 : Related ?
User: Related to #DP-1234

Q7 : Priority ?
User: medium

Q8 : Labels ?
User: backend

Q9 : Estimate ?
User: 3

Q10 : Assignee ?
User: isabelle.lafont@beta.gouv.fr

[Ticket créé avec toutes les informations]
```

### Exemple 2 : Bug Rapide

```
User: /create-linear-ticket bug

Claude: Type détecté : Bug

Q2 : Titre du ticket ?
User: Erreur 500 validation email avec accents

[Questions suivantes...]
```

## Validation Automatique

Avant de créer, vérifier :

- [ ] Titre < 60 caractères
- [ ] Type [TYPE] présent dans titre
- [ ] Context non vide
- [ ] Au moins 3 acceptance criteria
- [ ] Priority définie
- [ ] Au moins 1 label domain

Si validation échoue, demander correction.

## Ressources

- **Template** : `.claude/templates/linear-ticket-template.md`
- **Linear MCP** : configuré en scope local (authentification OAuth)
- **Standards DataPass** : `CLAUDE.md` section Linear Context

## Troubleshooting

### Problème : MCP non disponible

**Solution :** Vérifier avec `/mcp` que `linear-server` est connecté.

### Problème : Erreur d'authentification

**Solution :** Lancer `/mcp` → sélectionner `linear-server` → Authenticate.

---

**Note :** Ce skill garantit que tous les tickets DataPass suivent les mêmes standards de qualité et de documentation.
