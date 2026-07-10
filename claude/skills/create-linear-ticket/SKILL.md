---
name: create-linear-ticket
description: Create Linear ticket for DataPass following project standards with interactive wizard
argument-hint: [ticket-type]
allowed-tools: [Read, mcp__linear-server__*]
---

# Create Linear Ticket

Assistant interactif pour créer des tickets Linear conformes aux standards DataPass.

**Principe directeur : constat métier d’abord, solution technique ensuite. Descriptions courtes et lisibles.**

## Quand Utiliser

**✅ Utiliser quand :**
- Besoin de créer un nouveau ticket Linear
- Garantir respect des standards projet
- Aide à la rédaction structurée
- Feature, Bug, A11y, ou autre type

**❌ Ne PAS utiliser quand :**
- Ticket déjà créé (utiliser update)
- Duplication d’un ticket existant

## Template de Référence

Ce skill suit le canevas **« constat métier d’abord »** :
**`.claude/templates/linear-ticket-template.md`**

Canevas : **Constat → Objectif → Proposition technique → Critères d’acceptation → Hors périmètre.**

## Workflow Interactif

### Étape 1 : Lire le Template

Lire `.claude/templates/linear-ticket-template.md` pour référence.

### Étape 2 : Poser les Questions

Questions dans l’ordre du canevas (le quoi / pourquoi avant le comment) :

#### Q1 : Type de Ticket

**Options :** `feature` · `bug` · `refactor` · `a11y` · `docs` · `test` · `chore`

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

#### Q3 : Constat (métier — le problème, pas la solution)

**À inclure :**
- Le problème vécu / la friction, côté métier, utilisateur ou conformité.
- Factuel : ce qui se passe aujourd’hui. **Aucune solution ici.**

**Question :** Quel est le constat métier qui justifie ce ticket ?

---

#### Q4 : Objectif

**À inclure :**
- Ce qu’on veut obtenir, du point de vue de la valeur (1 à 2 phrases).

**Question :** Quel est l’objectif visé ?

---

#### Q5 : Proposition technique

**À inclure :**
- Approche envisagée, fichiers / composants clés.
- Points d’attention : architecture, DSFR, i18n, RGAA, sécurité.
- Rester synthétique — le détail fin va dans le plan, pas dans le ticket.

**Question :** Comment compte-t-on s’y prendre ? (proposition, pas roman)

---

#### Q6 : Critères d’acceptation (3 à 5, resserrés)

Bonne pratique DataPass — **toujours présents.**

**À inclure :**
- Chaque critère mesurable et testable, idéalement en Gherkin : « Étant donné … quand … alors … ».
- Liste numérotée par défaut. **Option gros ticket** : tableau `| CA | Description | État |` + Règles de gestion (RG) formalisées à part.

**Exemples :**
- CA-1 : Étant donné la page liste, quand je clique « Exporter CSV », alors un fichier se télécharge.
- CA-2 : L’export contient ID, date, demandeur, statut.

**Question :** Quels sont les critères d’acceptation ? (3 à 5)

---

#### Q7 : Hors périmètre (optionnel)

**À inclure :**
- Ce qui n’est explicitement **pas** traité ici, et vers quel ticket ça renvoie.

**Question :** Quelque chose à exclure explicitement du périmètre ?

---

#### Q8 : Priority

**Options :** `high` (bloquant) · `medium` (planifié) · `low` (nice to have)

**Question :** Quelle priorité ?

---

#### Q9 : Labels

**Domain (obligatoire) :** `backend` · `frontend` · `accessibility` · `infrastructure` · `documentation`
**Type (optionnel) :** `security` · `performance` · `ux` · `api` · `database`

**Question :** Quels labels ? (domain + optionnels)

---

#### Q10 : Estimate (optionnel)

**Points :** `1` (< 2h) · `2` (2-4h) · `3` (1j) · `5` (2-3j) · `8` (1 sem) · `13` (à découper)

**Question :** Estimation en points ?

---

#### Q11 : Related / Dépendances (optionnel)

**À inclure :** bloqué par / lié à DP-XXXX, docs, maquettes.

**Question :** Tickets ou docs liés ? Dépendances ?

---

#### Q12 : Assignee (optionnel)

**Question :** Assigner à quelqu’un ? (email ou @mention Linear)

---

### Étape 3 : Formater le Ticket

Générer la description au **canevas « constat métier d’abord »** :

```markdown
## Constat

[Q3 — le problème métier, factuel]

## Objectif

[Q4 — la valeur visée]

## Proposition technique

[Q5 — approche + fichiers clés + points d’attention]

## Critères d’acceptation

1. [CA-1, idéalement en Gherkin]
2. [CA-2]
3. Tests verts (RSpec + Cucumber), linter propre (Rubocop + StandardJS), RGAA respecté.

## Hors périmètre

- [Q7, si fourni]
```

**Option tickets complexes** — CA en tableau + Règles de gestion à part :

```markdown
## Règles de gestion

| **RG** | **Description** | **État** |
| -- | -- | -- |
| RG-1 | [Règle] | ✅ OK &#10;❌ KO |

## Critères d’acceptation

| **CA** | **Description** | **État + RG** |
| -- | -- | -- |
| CA-1 | [Critère Gherkin] | ✅ OK &#10;❌ KO &#10;RG - 1 |
```

**Notes de format :**
- Constat en tête, **jamais** la solution en premier.
- Garder court : le détail d’implémentation va dans le plan (`.claude/plans/…`), pas dans le ticket.
- `&#10;` = saut de ligne en cellule de tableau.
- Apostrophe typographique (’) et guillemets français (« ») dans tout le contenu.

### Étape 4 : Validation

Afficher l’aperçu (Titre · Priority · Labels · Estimate · Description) et demander : ✅ Créer ce ticket ? (yes/no)

### Étape 4bis : Choix de l’équipe

Avant de créer, demander si pas déjà précisé :

```
Quelle équipe Linear ?
  1. DataPass (key DP)        — team 41f8feef-8341-44b0-9dc8-bd2cd44e514f
  2. API Parteprise (key API) — team 06f4c81a-3435-400e-a2a7-68807d6cc14b
```

Par défaut : DataPass. Choisir API Parteprise pour les tickets liés au projet « Api Parteprise : Mise en conformité » ou tout sujet API Entreprise / API Particulier.

### Étape 5 : Créer via Linear MCP

Si confirmation, créer via `mcp__linear-server__save_issue` avec : `title`, `team` (ID choisi à l’étape 4bis), `description` (markdown), `priority` (mapping), `labels`, `estimate`, `assignee`.

**Mapping Priority :** `high` → 1 (Urgent) · `medium` → 2 / 3 (High / Medium) · `low` → 4 (Low)

### Étape 6 : Confirmer

Afficher l’`identifier` et l’URL retournés par Linear (le préfixe `DP-` ou `API-` vient de Linear) :

```
✅ Ticket créé — {identifier} : [Titre]
🔗 {url}
```

## Validation Automatique

Avant de créer, vérifier :

- [ ] Titre < 60 caractères, `[TYPE]` présent
- [ ] **Constat** métier non vide (le problème, pas la solution)
- [ ] **Objectif** présent
- [ ] Au moins 3 critères d’acceptation
- [ ] Priority définie
- [ ] Au moins 1 label domain

Si validation échoue, demander correction.

## Exemple

```
User: /create-linear-ticket feature

Q2 Titre : Ajouter export CSV des habilitations
Q3 Constat : Les instructeurs recompilent à la main leurs habilitations pour leurs
   rapports mensuels (~30 min/mois × ~20 instructeurs). Aucun export n’existe aujourd’hui.
Q4 Objectif : Leur permettre d’exporter la liste filtrée en un clic.
Q5 Proposition technique : CsvExporterService + route GET
   /instructor/authorization_requests/export.csv, gem CSV standard, respecte les filtres actifs.
Q6 CA :
   1. Bouton « Exporter CSV » visible sur la page liste.
   2. L’export contient ID, date, demandeur, API, statut.
   3. L’export respecte les filtres actifs ; fichier nommé habilitations_YYYY-MM-DD.csv.
   4. Tests verts, linter propre.
Q7 Hors périmètre : export PDF (→ ticket dédié).
Q8 medium · Q9 backend · Q10 3 · Q12 isabelle.lafont@beta.gouv.fr

[Ticket créé au canevas « constat métier d’abord »]
```

## Ressources

- **Template** : `.claude/templates/linear-ticket-template.md`
- **Linear MCP** : scope local (authentification OAuth)
- **Standards DataPass** : `CLAUDE.md`

## Troubleshooting

- **MCP non disponible** → vérifier avec `/mcp` que `linear-server` est connecté.
- **Erreur d’authentification** → `/mcp` → `linear-server` → Authenticate.

---

**Note :** Ce skill garantit que tous les tickets DataPass suivent le même canevas — constat métier d’abord, descriptions courtes, et critères d’acceptation systématiques.
