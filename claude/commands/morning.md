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

### 1b. Reporter la section vacances (active jusqu’au 2026-07-17)

Si le dernier daily log contient une section « 🏖 À clôturer avant les vacances » :
- La recopier dans le nouveau daily, juste après « 📥 Contexte de la veille », en ne gardant que les items **non cochés** (`- [ ]`) et les sous-titres qui en contiennent encore.
- Mettre à jour le compteur de jours ouvrés restants avant le départ (départ le vendredi 2026-07-17 ; mercredis off, jeudi 9 juillet indisponible).
- Signaler dans le résumé du matin les items bloquants restants.
- Ne rien reporter si tous les items sont cochés. Supprimer cette étape 1b au retour de vacances (mi-août – début septembre).

### 2. Fetcher les tickets Linear assignés

Via MCP Linear, récupérer les issues assignées à Isabelle
(user ID `733836f2-a572-4acd-bd62-b70ce08c6421`) **sans filtrer par équipe** —
les tickets peuvent être dans **DataPass Produit (key `DPP`, nouvelle équipe PO Natalia, socle produit actuel)**, DataPass (key `DP`, historique) ou API Parteprise (key `API`).
Filtrer : statuts In Progress + Todo, triés par priorité.

Conserver le `identifier` Linear (ex: `DPP-42`, `DP-1234` ou `API-6735`) tel quel dans tout le daily log.

### 2b. Relever les briefs en attente d'une réponse

Les brouillons produits par `po-assistant` restent bloqués tant qu'une question
n'a pas trouvé sa réponse — côté Natalia pour un arbitrage produit, côté
demandeur pour un champ manquant.

```bash
ls .claude/po-brief/ 2>/dev/null
```

Pour chaque fichier, lire le frontmatter et les sections « Pour Natalia » et
« Champs manquants ». Un brief est **en attente** si l'une des deux est non vide.

Les faire apparaître dans le résumé du matin, avec leur âge en jours ouvrés :

> 📥 Briefs en attente : « <objet> » (3 j — question à Natalia),
> « <objet> » (1 j — 2 champs manquants côté demandeur)

Règles :
- **Au-delà de 5 jours ouvrés**, signaler explicitement comme relance à faire.
- Ne rien relancer automatiquement : ni mail, ni message, ni ticket.
- Si le dossier est vide ou n'existe pas : sauter l'étape sans rien afficher.

### 3. Évaluer si un contexte suffisant existe

**Contexte suffisant** si au moins l'une de ces conditions est vraie :
- Des tickets Linear In Progress sont assignés
- Le dernier log contient des priorités pour aujourd'hui
- Un fichier HANDOVER ou CONTEXTE récent existe dans `.claude/plans/`

**Si contexte insuffisant** (tout vide / tout terminé / aucun ticket assigné) :
Poser une ou deux questions pour orienter la journée :
- « Sur quel ticket ou sujet veux-tu travailler aujourd'hui ? »
- « Y a-t-il un contexte particulier à charger ? »

### 3b. Détecter automatiquement le livrable du jour

Sans poser de question, identifier **un seul ticket principal** pour la journée.

**Règle de sélection :** parmi les tickets In Progress assignés à Isabelle, hors ceux bloqués sur une action externe (rien à faire aujourd'hui), prendre la **priorité Linear la plus haute** — à égalité, le plus ancien In Progress.

**Déduire une définition de done minimale** d'après le type et l'état du ticket (audit → pages/composants audités ; bug/fix → fix + tests verts + PR ; review → commentaires postés ; défaut → une action concrète et tracée sur le ticket).

**Compteur de reports — exclure un ticket reporté 3 fois.** Avant de retenir le candidat, compter ses reports dans les 15 derniers daily logs : un report = un jour où le ticket était « Livrable du jour » ou priorité n°1 de la veille, **sans** apparaître dans « 🏆 Réalisations du Jour » de ce même jour. Un jour où le log note un arbitrage explicite (« écarté au profit de… ») compte aussi comme report.

- **Moins de 3 reports** → le ticket peut être retenu.
- **3 reports ou plus** → ne **pas** le retenir comme livrable, passer au candidat suivant selon la même règle. L'inscrire dans la section « ⏸ À renégocier » du daily, avec son nombre de reports et ces quatre options :
  > **[[DP-XXXX]]** — reporté N fois. À trancher aujourd'hui, par écrit, avec quelqu’un (PO, manager, collègue) : **faire** demain (créneau bloqué) · **découper** (plus petit livrable tenable en une journée) · **rendre** (réassigner) · **abandonner** (fermer ou repasser en Backlog).
- Le ticket sort de « À renégocier » dès qu'une de ces options est notée dans un daily (Notes de Travail ou Linear). Ne jamais relancer le compteur tant que rien n'est noté.
- Ne jamais trancher à la place d'Isabelle : afficher, pas décider.

### 3c. Détecter le méta-travail et marquer la timebox

Un ticket est **méta-travail** si son titre contient l'un de ces mots-clés (casse ignorée) :
`skill`, `plugin`, `claude code`, `commande`, `outil`, `tooling`, `prompting`, `guide`, `dotfile`
— ou s'il n'est lié à aucun livrable utilisateur DataPass direct (pas de vue, pas de modèle, pas de bug prod).

Si un tel ticket est In Progress : noter `⏱ Timebox 30 min` à côté dans la liste des tickets du daily.

### 4. Créer le daily log du jour

Si le fichier `/Users/isalafont/code/BetaGouv/note_datapass/Journal/Daily/YYYY-MM-DD.md` n'existe pas encore, le créer.

**Pour chaque ticket en cours**, lire sa note dans le vault (`Tickets/{KEY}-XXXX.md` ou `Tickets/YYYY-MM/{KEY}-XXXX/index.md`, où `{KEY}` est `DP` ou `API`) et récupérer le champ `epic` du frontmatter. S'il est renseigné, ajouter `(epic: [[{epic-id}]])` après le titre dans la liste des tickets du daily log.

**Déterminer les tags Obsidian** depuis les tickets en cours, selon la « Taxonomie de tags validée » plus bas. En plus :
- Lire `.claude/current-cycle.md` → ajouter le tag cycle (ex: `#cycle4`). Si lundi ET fichier absent ou daté d'une autre semaine : demander à Isabelle le cycle en cours, puis écraser le fichier.

```markdown
---
date: YYYY-MM-DD
day: {Jour}
tickets: [DP-XXXX, DP-XXXX]
tags: [tag-feature, tag-domaine]
---

# YYYY-MM-DD - {Jour de la semaine}
#{tag-feature} #{tag-domaine}

## 🎯 Livrable du jour

> **[[DP-XXXX]]** — {Titre court du ticket principal}
> Done = {définition de done minimale déduite automatiquement}

## ⏸ À renégocier

- **[[DP-XXXX]]** — reporté N fois : faire · découper · rendre · abandonner — à trancher par écrit avec {qui}

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
- Domaines : `#admin-ui` · `#formulaire` · `#data-provider`
- Cycle : tag lu depuis `.claude/current-cycle.md` (ex: `#cycle4`)
- Types : `#test-coverage` · `#bug` · `#refacto`

**Sections à omettre si vides** : ne pas inclure "⏸ À renégocier", "👀 En review" ou "✅ Done" si aucun ticket dans ce statut au matin.

Si le fichier existe déjà (morning lancé deux fois dans la journée) :
ne pas l'écraser, juste afficher le résumé.

### 5. Afficher le résumé à Isabelle

Présenter clairement :
- Ce qui était en cours hier (ou "Nouveau départ" si rien)
- Les tickets prioritaires du jour (Linear)
- Les tickets à renégocier (3 reports ou plus), en tête du résumé s'il y en a
- L'emplacement du daily log

---

## ⚠️ Règles

Ne jamais modifier un log d'un jour précédent, ni écraser un daily déjà créé aujourd'hui (afficher le résumé à la place).

---

## 🔗 Commandes liées

- `/evening` — Terminer la journée et clôturer le suivi
- `/handover` — Snapshot de passation entre sessions
- `/weekly` — Rapport hebdomadaire