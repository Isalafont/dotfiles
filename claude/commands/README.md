# Commandes Claude Code — DataPass

Ces commandes sont disponibles dans toutes les sessions Claude Code sur ce projet.
Elles s'invoquent avec `/nom-de-la-commande` dans l'interface Claude Code.

---

## Quelle commande utiliser ?

```
Début de journée                             →  /morning
Fin de journée                               →  /evening
Fin de session sans clôturer la journée      →  /handover
Snapshot de contexte en cours de session     →  /recap

Je veux planifier sans coder aujourd'hui     →  /plan DP-XXXX
J'ai un plan validé, je veux coder           →  /implement-plan
Je veux aller du ticket à la PR en une session → /ship DP-XXXX
Je veux reviewer une PR                      →  /review
Je veux débugger un problème                 →  /debug
Je veux vérifier que tout est OK avant deploy →  /deploy-check
Je veux corriger un plan après feedback      →  /replan
Je veux archiver un ticket terminé           →  /archive DP-XXXX
Je veux archiver un plan de recherche        →  /archive PLAN_mon-sujet.md
Je veux créer une note de travail            →  /document [type]
Rapport de fin de semaine                    →  /weekly
Bilan de fin de mois                         →  /monthly
```

---

## Suivi quotidien

### `/morning`

Démarre la journée : lit le dernier daily log, fetche les tickets Linear assignés, crée le daily log du jour avec les tickets en cours annotés de leur epic.

---

### `/evening`

Clôture la journée : met à jour le daily log (réalisations, tickets travaillés, priorités lendemain), appende une ligne dans la section "Sessions de travail" de chaque ticket travaillé, met à jour le statut dans la note epic.

---

### `/handover`

Génère un snapshot `HANDOVER_*.md` pour passer le contexte à une autre session : ce qui a été fait, les décisions prises, les gotchas, les fichiers clés, les prochaines étapes.

---

### `/recap`

Crée ou met à jour un fichier `CONTEXTE_*.md` dans `.claude/plans/` — document vivant qui évolue au fil des sessions sur un même sujet.

---

## Développement

### `/plan [DP-XXXX | fichier]`

Prépare le travail **sans coder**.

1. Fetch le ticket Linear (ou lit un fichier spec)
2. Pose des questions de clarification une par une
3. Génère `context.md` et attend validation
4. Explore le codebase de manière ciblée
5. Génère `plan.md` détaillé
6. Propose d'enrichir la description du ticket Linear

```bash
/plan DP-1234        # depuis un ticket Linear
/plan spec/feature   # depuis un fichier de spec
/plan                # reprend la session en cours
```

---

### `/implement-plan`

Exécute un `plan.md` déjà validé, étape par étape.

Ordre obligatoire : Models + tests → Services/Organizers + tests → Controllers + views → Cucumber. Lance les tests et le linter après chaque étape.

---

### `/ship [DP-XXXX]`

Workflow complet : **ticket Linear → PR mergeable** en une session.

Enchaîne `/plan` + `/implement-plan` + commit + push + création de PR via `gh`. Tous les tests doivent passer avant le push.

---

### `/replan`

Réécrit un plan existant après annotations `FIXME`. Lit le fichier annoté, identifie les changements, réexplore le codebase si nécessaire.

---

## Qualité

### `/review`

Review PR structurée en 7 axes : contexte, feedback existant, remise en question de l'implémentation, qualité du code, bonnes pratiques Rails, couverture de tests, documentation.

---

### `/deploy-check`

Validation complète avant déploiement : rubocop, standard (JS), RSpec, Cucumber.

---

### `/debug`

Workflow debugging en 5 étapes : reproduire → collecter → analyser → proposer → implémenter (TDD). Produit un rapport de session.

---

## Archivage et documentation

### `/archive [DP-XXXX | fichier]`

Deux modes selon l'argument :

**Mode ticket** — `DP-XXXX` :
- Copie `.claude/plans/DP-XXXX/` → vault `Tickets/YYYY-MM/DP-XXXX/`
- Crée `index.md` avec frontmatter et wikilinks
- Met à jour la note epic si applicable

**Mode recherche** — nom de fichier sans ID ticket :
Routing automatique par préfixe vers le vault Obsidian :

| Préfixe | Destination vault |
|---------|------------------|
| `PLAN_*` | `Recherche/` |
| `CONTEXTE_*` | `Recherche/` |
| `rapport-*` | `Documentation/` |
| `PROPOSITION_*` | `Suivi/` |
| `review-*` | `Suivi/` |

```bash
/archive DP-1234
/archive PLAN_agents-claude.md
/archive rapport-secu-vm.md
```

---

### `/document [type]`

Crée une note de travail dans `.claude/plans/` avec préfixe automatique, puis archivable via `/archive`.

| Type | Préfixe | Destination finale |
|------|---------|-------------------|
| `plan` | `PLAN_` | `Recherche/` |
| `contexte` | `CONTEXTE_` | `Recherche/` |
| `rapport` | `rapport-` | `Documentation/` |
| `proposition` | `PROPOSITION_` | `Suivi/` |
| `review` | `review-` | `Suivi/` |
| `feature DP-XXXX` | *(aucun)* | `Tickets/YYYY-MM/DP-XXXX/` direct |

```bash
/document plan          # investigation en cours
/document rapport       # rapport technique
/document feature DP-1234  # doc d'implémentation → vault direct
```

---

## Rapports

### `/weekly`

Rapport hebdomadaire : agrège les daily logs de la semaine, statistiques tickets/PRs/présence, graphiques Mermaid, section epics travaillées.
Inclut une comparaison vs la semaine précédente (deltas ↑↓=), une section "Travail hors-ticket" (tooling, config, reviews), et une estimation de charge pour la semaine suivante (🟢/🟡/🔴).
Génère `Journal/Reports/Weekly/WEEK_YYYY-WNN.md`.

---

### `/monthly`

Bilan mensuel : agrège les weekly reports, tendances, epics du mois, leçons récurrentes.
Inclut une comparaison vs le mois précédent (deltas ↑↓= sur tickets, PRs, présence), une section "Travail hors-ticket du mois" agrégée depuis les weekly reports, et une estimation de charge pour le mois suivant (🟢/🟡/🔴).
Génère `Journal/Reports/Monthly/MONTH_YYYY-MM.md`.

---

## Fichiers de travail

Les commandes génèrent leurs fichiers dans `.claude/plans/` (gitignored) :

```
.claude/plans/
├── DP-XXXX/                    # dossier ticket (plan + contexte)
├── PLAN_*.md                   # investigations → Recherche/ via /archive
├── CONTEXTE_*.md               # contextes de session → Recherche/ via /archive
├── rapport-*.md                # rapports → Documentation/ via /archive
├── PROPOSITION_*.md            # propositions → Suivi/ via /archive
├── review-*.md                 # reviews → Suivi/ via /archive
├── _plan-session.md            # session en cours (/plan)
├── _ship-session.md            # session en cours (/ship)
└── HANDOVER_*.md               # snapshots de handover
```

---

## Configuration

- `.claude/settings.json` — permissions, hook `WorktreeCreate` (symlink commandes auto)
- `.claude/personal-context.md` — identité, IDs Linear, chemins vault Obsidian
- `.claude/skills/` — skills locaux (create-linear-ticket, component-creation, dsfr-skill)
- `~/dotfiles/claude/commands/` — source des commandes (symlinkée ici et dans tous les worktrees)
