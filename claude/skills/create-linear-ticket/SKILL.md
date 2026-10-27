---
name: create-linear-ticket
description: Crée un ticket Linear DataPass au bon canevas (US, TS, Bug, Cadrage, Demande externe) sur l'équipe DataPass Produit, en respectant le process de triage
argument-hint: [us|ts|bug|cadrage|demande-externe]
allowed-tools: [Read, mcp__linear-server__list_templates, mcp__linear-server__get_template, mcp__linear-server__list_issues, mcp__linear-server__get_issue, mcp__linear-server__list_projects, mcp__linear-server__save_issue]
---

# Créer un ticket Linear DataPass

**Principe directeur : le canevas fait foi.** Les templates vivent dans Linear, pas dans ce
fichier. Avant d’écrire, lire le template concerné avec `get_template` — ce skill dit
*lequel* choisir et *comment* le remplir, Linear dit *quoi* contient chaque section.

**Ton attendu : court, concis, précis. Peu verbeux.** Une décision se pose en trois lignes ;
sa justification tient dans la même phrase. Pas de retour d’expérience narratif, pas de
paragraphe qui répète le tableau au-dessus.

## Équipe et périmètre

| | |
| -- | -- |
| **Équipe par défaut** | **DataPass Produit** — key `DPP`, id `827e18e6-8a64-477e-b05a-88217fdefacc` · https://linear.app/pole-api/team/DPP |
| **API Parteprise** | key `API`, id `06f4c81a-3435-400e-a2a7-68807d6cc14b` — uniquement pour les sujets API Entreprise / API Particulier (sites vitrines, audits RGAA de leurs pages) |
| **DataPass (`DP`)** | id `41f8feef-8341-44b0-9dc8-bd2cd44e514f` — **équipe historique en extinction. Ne plus y créer de ticket.** Le backlog produit est repris dans DPP |

### Équipe humaine

| Personne | Rôle | Linear |
| -- | -- | -- |
| Natalia Bertel | **PO DataPass** — trie, priorise et découpe les demandes | `natalia.bertel.ext@numerique.gouv.fr` |
| Eva Spaeter | Autrice des User Stories | `eva.spaeter.ext@numerique.gouv.fr` |
| Jean-Baptiste Feldis | Dev | `jean-baptiste.feldis@beta.gouv.fr` |
| Isabelle Lafont | Dev | `isabelle.lafont@beta.gouv.fr` |

Hors équipe DPP mais présents dans le workspace : Loïc Delmaire (`skelz0r`, API Entreprise /
Particulier), Vincent Mazalaigue.

## Choisir le canevas

Cinq templates existent sur DPP. Ne pas en inventer un sixième.

| Situation | Template | Statut à la création |
| -- | -- | -- |
| Une demande arrive de l’extérieur (FD, partenaire, support) | **Demande externe — Formulaire** | **Triage** |
| Un besoin utilisateur déjà cadré | **US — User Story** | Backlog |
| Un chantier technique : dette, sécurité, prérequis d’une US | **TS — Technical Story** | Backlog |
| Un comportement anormal, reproductible | **Bug** | Backlog |
| Une question à trancher avant de pouvoir écrire des US | **Cadrage** | Backlog |

## Process de triage — demandes externes

C’est le point le plus souvent raté. Une demande externe **n’est pas** une US.

1. La demande entre en **Triage**, au template « Demande externe — Formulaire ».
2. **Sans projet, sans label, sans priorité, sans assigné.** Natalia les pose ensuite.
3. Natalia trie, priorise, et **découpe la demande en US / TS** rattachées au bon projet.
4. Le ticket de demande garde la trace de l’échange avec le demandeur ; les US qui en
   découlent portent le travail.

**Garde-fou** — un ticket de demande externe converti en US doit être **relié** à l’US
(relation Linear) et sorti du Triage. Sinon il y reste indéfiniment et le backlog se
retrouve avec deux tickets sur le même sujet : c’est le doublon le plus fréquent du
backlog DPP (constaté le 03/09/2026 sur cinq paires HubEE / ANS).

**Ne jamais créer de ticket ou de projet Linear pour un chantier métier de sa propre
initiative.** C’est le rôle de la PO. Signaler le besoin, proposer un brouillon — pas créer.

## Projets DPP

Réservés aux US / TS **déjà cadrées**. Une demande externe n’est jamais rattachée à un projet.

| Projet | id |
| -- | -- |
| Demandes FD | `7adc80c7-d6ab-4624-953d-4b99765bf659` |
| Espace FD: édition en autonomie | `e6b05db3-e75c-41c0-86d9-cbf142ad335e` |
| Dette & fiabilité | `f3c8944a-233f-496d-99f6-19eded6b7d3f` |
| Notifications & emails | `58af6ade-df70-4c7b-bc19-0e8283ffbc9a` |
| Sécurité applicative | `b689330c-29ea-4cac-8f1f-f062443889ee` |
| Formulaires éditeurs DGFiP | `91292a01-61a3-40a3-a0e0-96bbce9a006c` |
| Décommission des Bacs à Sable DGFiP *(Paused)* | `ab1a9a7d-ccae-4f57-9782-3a463a3632ac` |
| Aide à l’instruction *(Paused)* | `cc0ef08c-92fa-4322-8d05-489a76746a08` |
| Proactivité — suites CNOUS / CNAF | `bfbc9a63-d70e-421e-a1c5-cfa06eaf585b` |
| Gestion des éditeurs | `92cde6b2-1ee8-4099-8b91-9899ed800611` |
| Onboarding & proposition de valeur FD | `3215ba04-f877-4896-a1c1-f8a7c4c98be5` |
| Découplage — chantiers dépriorisés (parking documenté) | `9f538da8-ded9-4ecd-ab33-ac67a50b1746` |

Un projet d’une autre équipe n’est pas rattachable : Linear refuse avec
`project is not associated with the issue's team`. Mentionner le rattachement en texte et
poser une relation vers le ticket de l’autre équipe.

## Labels DPP

Fournisseur de données : `FC` · `HUBEE` · `ANS` · `URSSAF` · `DGFIP` · `API PART`
Nature : `Bug` · `Improvement` · `Feature`

Il n’existe **pas** de labels `backend`, `frontend`, `accessibility` ou `infrastructure`
sur DPP — ne pas les inventer.

## Forme des tickets

### Double colonne d’état et bloc DoR / DoD

Depuis l’atelier DoR / DoD du 14/09/2026, le template US porte deux évolutions qui
s’appliquent **à l’US comme à la TS** :

- **Deux colonnes d’état** au lieu d’une — `État producteur` et `État testeur`, remplies
  en cases à cocher markdown et non en symboles :
  `- [ ] OK <br>- [ ] KO`. Sur les critères d’acceptation, la RG couverte se met dans la
  colonne producteur, après les cases : `- [ ] OK <br>- [ ] KO<br><br>RG1`.
- **Un bloc DoR / DoD** en toute fin de description, tableau à deux colonnes
  `**DOR** | **DOD**`, huit lignes chacune, cases à cocher. Le copier **tel quel** depuis
  `get_template` — il ne se réécrit pas, ne se raccourcit pas, et les lignes sans objet
  pour le ticket restent présentes et décochées.

⚠️ Ne plus utiliser `✅ OK / ❌ KO` : c’était l’ancien format, antérieur à l’atelier.

### US — User Story

Tableau d’en-tête (Priorité MUST/SHOULD/COULD · Description « En tant que… je veux… afin
de… » · Contexte · Rédactrice · Maquettes · Dépendances · **Utilisateurs concernés** —
qui est impacté et volume estimé · **Valeur métier** — ce que ça change, avec un indicateur
et un ordre de grandeur), puis :

- `## Règles de gestion` — tableau `# | Règle | État producteur | État testeur`, lignes
  `RG1`, `RG2`…
- `## Critères d’acceptation` — tableau
  `# | Étant donné | Quand | Alors | État + RG producteur | État + RG testeur`,
  lignes `CA1`… Prévoir un CA accessibilité et un CA non-régression.
- `## Hors périmètre` — tableau `Exclu | Pourquoi / où c’est traité`
- `## Historique & références` — inclut `Ticket(s) d’origine`, `Décisions liées`,
  `Contexte hérité`
- le bloc `**DOR** | **DOD**`

### TS — Technical Story

Tableau d’en-tête (Priorité · Objectif technique · Contexte · Pourquoi maintenant ·
Rédactrice · Dépendances), puis `## Périmètre technique` en tableau `# | Élément | Détail`
(`PT1`, `PT2`…) et `## Historique & références`.

⚠️ **Le template TS est resté à sa version du 03/08/2026 : ni les deux colonnes d’état, ni
le bloc DoR / DoD, ni la section de critères n’y figurent.** Les ajouter à la main, au
format de l’US, pour que les deux types se lisent pareil :

- en-tête : compléter avec **Utilisateurs concernés** et **Valeur métier** — pour une TS,
  l’utilisateur est souvent l’équipe technique et la valeur se mesure en risque évité,
  en temps de CI ou en dette levée ;
- `## Critères de Done` — tableau `# | Critère | État producteur | État testeur`, lignes
  `D1`, `D2`… ;
- `## Hors périmètre` — tableau `Exclu | Pourquoi` ;
- le bloc `**DOR** | **DOD**`, recopié du template US.

Modèle de référence : [DPP-115](https://linear.app/pole-api/issue/DPP-115) (15/09/2026).
Si le template TS est mis à jour côté Linear, retirer ce paragraphe et laisser `get_template`
faire foi.

### Bug

Tableau d’en-tête (Priorité · Comportement observé · Comportement attendu · Impact & volume ·
Environnement · Signalé par), puis `## Étapes de reproduction` en tableau
`# | Étape | Résultat`, `## Pièces jointes`, `## Historique & références`.

### Cadrage

Tableau d’en-tête (Question à trancher — **une seule**, fermée si possible · Pourquoi
maintenant · Timebox 2 à 5 jours · Livrable — jamais du code · Personnes à consulter), puis
`## Suites possibles` en tableau `Si la réponse est… | Alors on crée…` et
`## Historique & références`.

## Workflow

1. **Vérifier l’antériorité.** `list_issues` sur DPP avec un mot-clé du sujet, archives
   comprises. Un doublon coûte plus cher que trente secondes de recherche.
2. **Choisir le canevas** dans le tableau ci-dessus.
3. **Lire le template** avec `get_template` pour avoir la structure exacte à jour.
4. **Rédiger**, en respectant les conventions de forme ci-dessous.
5. **Soumettre l’aperçu à Isabelle avant création** — titre, équipe, projet, statut, labels,
   description. Toujours, sans exception.
6. **Créer** avec `save_issue` (`team`, `title`, `description`, et selon le cas `project`,
   `labels`, `priority`, `assignee`, `state`).
7. **Confirmer** avec l’identifier et l’URL renvoyés par Linear.

## Conventions de forme

- **Apostrophe typographique** (’) et **guillemets français** (« ») dans tout le contenu.
- Titres : `US — [verbe + objet + pour qui]` · `TS — [verbe technique + objet]` ·
  `Bug — [symptôme + où]` · `[Cadrage] [sujet] — [question]` ·
  `Demande externe — {Organisation} : {objet}`.
- Pas de référence de ticket dans les messages de commit liés — le nom de branche suffit.
- `&#10;` produit un saut de ligne dans une cellule de tableau.
- Le détail d’implémentation va dans le plan (`.claude/plans/`), pas dans le ticket.

## Ticket récurrent

Pour un rappel périodique (rotation de secret, revue semestrielle), Linear gère les
**recurring issues** : ouvrir le ticket, menu `…` > **Convert into > Recurring issue…**
(ou Cmd/Ctrl + K, « Convert into recurring issue »), puis choisir première échéance et
cadence. Alternative : **Team settings > Recurring issues** > `+`. Le ticket suivant est
créé à 00h01 le lendemain de l’échéance, dans le fuseau de l’équipe.

⚠️ Non pilotable par le MCP — c’est une manipulation dans l’UI. Et le récurrent est
**toujours un ticket distinct** du chantier ponctuel, qui doit pouvoir passer Done.

## Troubleshooting

- **MCP non disponible** → `/mcp` pour vérifier que `linear-server` est connecté.
  `linear-perso` est le workspace personnel : ne pas l’utiliser ici.
- **`project is not associated with the issue's team`** → le projet appartient à une autre
  équipe. Poser une relation plutôt qu’un rattachement.

## Ressources

- Templates : dans Linear (`list_templates` / `get_template`), scope `DPP`
- ⛔ `~/.claude/templates/linear-ticket-side-projects.md` est le canevas des **side-projects
  personnels** (workspace `linear-perso`). Il n’a rien à faire sur DataPass — ne jamais
  l’utiliser ici, même s’il ressemble au template US.
- Skills liés : `cadrer-projet-linear` (structurer un projet en milestones) ·
  `archive-ticket` · `sync-ticket`
