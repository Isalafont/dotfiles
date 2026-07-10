---
name: cadrer-projet-linear
description: Structurer un projet Linear DataPass en milestones (phases de valeur) et réécrire ses tickets au canevas « constat métier d’abord »
argument-hint: [projet]
allowed-tools: [Read, mcp__linear-server__*]
---

# Cadrer un projet Linear

Structure un projet Linear existant selon le référentiel DataPass : une description type, des milestones = phases de valeur, 100 % des tickets rattachés, et des descriptions de tickets au canevas « constat métier d’abord ».

Complément de **`create-linear-ticket`** (niveau ticket) : ici on travaille au **niveau projet**.

## Quand Utiliser

**✅ Utiliser quand :**
- Un projet Linear est un sac de tickets à plat, sans milestones.
- « Cadrer / structurer / mettre en milestones le projet X ».
- Reprendre ou nettoyer un backlog projet avant de le partager ou de le reprendre.

**❌ Ne PAS utiliser quand :**
- Créer un seul ticket → `create-linear-ticket`.
- Inventer du backlog métier de zéro (rôle du PO — voir Règles).

## Référentiel de cadrage

Modèle de référence : le projet Linear **« Robot d’instruction »**.

1. **Description projet type** : Objectif · Résultat attendu (mesurable) · Périmètre · Hors périmètre · Milestones (+ antériorité / lead si utile).
2. **Milestones = phases de valeur**, nommées par un état atteint, **ordonnées en trajectoire** — jamais des dates.
3. **3 à 6 milestones.** Au-delà, regrouper ; en deçà de 2, un milestone suffit peut-être.
4. **100 % des tickets actifs rattachés** à un milestone. Un ticket orphelin = un milestone manquant ou un ticket hors périmètre.
5. **~3 à 8 tickets par milestone.** Trop → re-découper.
6. **Ticket chapeau + sous-tickets** pour la décomposition (exploration, listing, pilotes multiples).
7. **Inconnues tracées en tickets `[Question]`**, rattachés au milestone où on doit trancher.
8. **Séparer le ponctuel du durable** : un incident / one-shot dans son propre milestone, la prévention ou le récurrent à part.

## Canevas de description de projet

```markdown
## Objectif
[Une phrase : ce que le projet vise, et pourquoi.]

## Résultat attendu
* [Résultats mesurables, un par ligne — noter « livré » pour ceux déjà faits.]

## Périmètre
* [Ce qui est traité, aligné sur les milestones.]

## Hors périmètre
* [Ce qui n’est explicitement pas traité, et où c’est traité sinon.]

## Milestones
* **[Phase 1]** — [le « done » de la phase, en une ligne].
* **[Phase 2]** — …
```

## Canevas de description de ticket

Réécrire chaque ticket au canevas **« constat métier d’abord »** (identique à `create-linear-ticket`) :

1. **Constat** (métier / problème vécu) — en premier, factuel, **sans solution**.
2. **Objectif**.
3. **Proposition technique**.
4. **Critères d’acceptation** (liste resserrée ; tableau CA/RG optionnel pour les gros tickets).
5. *Hors périmètre*.

## Workflow

### 1. Charger le projet
`get_project` (avec `includeMilestones`), `list_milestones`, `list_issues` (limite large).

### 2. Analyser
- Description actuelle : complète ? à jour ? section obsolète (ex. « Tickets T1/T2… ») ?
- Milestones existants (souvent 0).
- Tickets à plat : quels thèmes / phases émergent ? relations parent-enfant existantes ? tickets Done à rattacher pour la progression.

### 3. Proposer (AVANT toute écriture)
- Une **description projet** réécrite au canevas.
- Un **découpage en 3 à 6 milestones** ordonnés, avec le **mapping ticket → milestone** (Done inclus, pour une progression honnête).
- Les points à trancher (ticket à cheval, incident vs prévention, `[Question]`).
- **Faire valider le découpage** par l’utilisatrice.

### 4. Écrire (après validation)
- Créer les milestones : `save_milestone`, **un par un, séquentiellement** (l’ordre de création fixe l’ordre d’affichage ; l’API n’expose pas `sortOrder`).
- Rattacher les tickets : `save_issue` avec `milestone` = ID du milestone (rattacher **aussi** les Done).
- Appliquer la description projet : `save_project` (proposer / montrer avant).

### 5. Optionnel — après le squelette
- **Réécrire les descriptions** des tickets actifs au canevas ticket : procéder par un **ticket témoin**, valider le format, puis les autres.
- **Poser les dépendances** : `save_issue` `blockedBy` (ex. « masquer le token » bloque « one-click »).
- **Détacher / relier** : un sous-ticket qui change de milestone → `parentId: null` + `relatedTo` le chapeau, plutôt qu’un sous-ticket à cheval sur deux milestones.
- **Commentaire de réorganisation** (`save_comment`) sur les tickets déplacés, indiquant où sont désormais les tickets à traiter.

## Règles

- **Toujours proposer et faire valider avant toute écriture Linear.** Aucune création ni déplacement à l’aveugle.
- **Ne jamais créer de tickets métier** à la place du PO — cadrer et structurer l’existant, oui ; inventer du backlog métier, non.
- Milestones **par phase de valeur**, jamais par date.
- Rattacher aussi les tickets **Done** (progression honnête des milestones).
- Mentions inter-tickets : le texte `DP-XXXX` est auto-résolu en lien par l’API `save_issue`.
- Apostrophe typographique (’) et guillemets français (« ») partout.

## Exemple (résumé)

Projet « Sécurité applicative » (sac de 14 tickets, 0 milestone) →
- Description réécrite (Objectif / Résultat attendu / Périmètre / Hors périmètre / Milestones).
- **4 milestones ordonnés** : Durcissement session & authentification · Bannissement · Protection contre les abus · Réponse à l’incident staging.
- 14 tickets rattachés (Done inclus). Mesures préventives détachées de l’incident (`relatedTo`), dépendances posées, commentaire de réorganisation sur le ticket d’incident.

## Ressources

- Skill complémentaire (niveau ticket) : **`create-linear-ticket`**.
- Modèle de cadrage : projet Linear **« Robot d’instruction »**.
