---
name: side-project-ticket
description: Rédige un ticket Linear de side-project (workspace linear-perso) au template de son type — US, TS, Bug, Cadrage —, critères en tableau avec état producteur et état testeur. Jamais pour DataPass.
argument-hint: [us|ts|bug|cadrage]
allowed-tools: [Read, mcp__linear-perso__list_issues, mcp__linear-perso__get_issue, mcp__linear-perso__save_issue]
---

# Ticket de side-project

> ⛔ **Hors DataPass.** Ce skill sert aux projets personnels du workspace Linear
> `linear-perso`. Pour DataPass, les templates vivent dans Linear (équipe `DPP`) : skill
> `create-linear-ticket`. Ne jamais croiser les deux.
>
> Un projet qui versionne son propre skill de ticket (ex. `plan-ticket` dans knitproof) suit
> ses templates à lui, pas ceux-ci.

Socle repris des templates de l’équipe DataPass Produit (copie du 05/10/2026 dans le vault,
`Ressources/templates-linear-dpp/`), adapté au travail en solo.

## Choisir le template

| Template | Usage | Titre |
| -- | -- | -- |
| [US](templates/us.md) | Fonctionnalité visible par une personne qui utilise le projet | `US — [verbe + objet + pour qui]` |
| [TS](templates/ts.md) | Évolution technique, outillage, dette, prérequis d’une US | `TS — [verbe technique + objet]` |
| [Bug](templates/bug.md) | Anomalie : observé / attendu, reproduction | `Bug — [symptôme observé + où]` |
| [Cadrage](templates/cadrage.md) | Trancher une question en timebox, sans code | `[Cadrage] [sujet] — [question à trancher]` |

Une question ouverte, produit ou utilisateur, passe par le Cadrage tant qu’aucun besoin
propre n’apparaît ; un type « Exploration » fusionnant EXPLO et DISCO se créera à ce
moment-là.

## Règles communes

- Le template s’applique à **tout** ticket, quelle que soit sa taille. Une ligne sans objet
  reste présente, avec « aucune » ou « sans objet ».
- **Constat avant solution** : le contexte décrit le problème, la proposition vient ensuite.
- **Critères en tableau** `# | Étant donné | Quand | Alors | État producteur | État testeur`,
  quel que soit le type. Chaque critère est vérifiable par une commande, un test ou une
  observation.
- **Deux colonnes d’état**, en cases à cocher : `- [ ] OK <br>- [ ] KO`.
  - **État producteur** : coché par la session ou l’agent qui implémente, une fois le
    critère vérifié.
  - **État testeur** : coché par la revérification de la session principale, puis par
    Isabelle à la recette. Jamais par l’agent qui a produit.
  - La règle de gestion couverte se note dans la colonne producteur, après les cases :
    `- [ ] OK <br>- [ ] KO<br><br>RG1`.
- **Hors périmètre** en tableau `Exclu | Pourquoi / où c’est traité`, avec un renvoi.
- **DOR / DOD** en fin de description, copiées telles quelles depuis le template.
- Priorité, estimation, labels et relations se renseignent dans les champs Linear, pas dans
  la description.
- Le détail d’implémentation va dans le plan (`.claude/plans/`), pas dans le ticket.
- Apostrophe typographique (’) et guillemets français (« »). `<br>` pour un saut de ligne
  dans une cellule.

## Workflow

1. **Vérifier l’antériorité** : `list_issues` avec un mot-clé du sujet.
2. **Choisir le template** dans le tableau ci-dessus et le lire.
3. **Rédiger** en suivant les règles communes.
4. **Soumettre l’aperçu à Isabelle** : titre, équipe, projet, labels, priorité, description.
5. **Créer** avec `save_issue` seulement après son accord explicite, puis donner
   l’identifiant et l’URL renvoyés par Linear.
