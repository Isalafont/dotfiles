# Document → Vault Obsidian DataPass

Crée une note de travail dans `.claude/plans/` avec le bon préfixe,
ou une documentation de feature directement dans le vault.

## Usage

```
/document                    # mode interactif (demande le type)
/document plan               # investigation / recherche en cours
/document contexte           # contexte de session ou de sujet
/document rapport            # rapport technique ou audit
/document proposition        # proposition de workflow ou d'organisation
/document review             # review de PR ou de code hors ticket
/document feature DP-1234    # documentation d'une feature implémentée → vault direct
```

---

## Étape 1 : Détecter le mode

Si argument fourni → utiliser ce mode directement.
Sinon, demander :

```
Quel type de document ?

1. plan        — Investigation, exploration technique, recherche (ex: agents Claude, migration)
2. contexte    — Contexte de session ou de sujet de travail
3. rapport     — Rapport technique, audit, analyse de sécurité
4. proposition — Proposition de workflow, d'organisation, d'amélioration
5. review      — Review de PR ou de code hors ticket Linear
6. feature     — Documentation d'une feature implémentée (lié à un ticket)
```

---

## Convention préfixes et destinations

| Type | Préfixe fichier `.claude/plans/` | Destination vault via `/archive` |
|------|----------------------------------|----------------------------------|
| plan | `PLAN_` | `Recherche/` |
| contexte | `CONTEXTE_` | `Recherche/` |
| rapport | `rapport-` | `Documentation/` |
| proposition | `PROPOSITION_` | `Suivi/` |
| review | `review-` | `Suivi/` |
| feature | *(direct vault)* | `Tickets/YYYY-MM/DP-XXXX/` |

---

## Modes 1–5 : Notes de travail (`.claude/plans/`)

Ces notes sont créées dans `.claude/plans/` pour être travaillées en session,
puis archivées vers le vault via `/archive {nom-du-fichier}` quand elles sont finalisées.

### Questions (séquentielles — une à la fois)

1. **Titre** : Quel est le sujet ? (ex: "Agents Claude pour revue de PR", "Audit sécurité VM")
2. **Contexte** : Pourquoi cette note ? Quel problème ou question a déclenché ça ?
3. **Contenu principal** : Ce que tu sais déjà, les questions ouvertes, la décision ou le résultat ?
4. **Références** (optionnel) : Tickets liés, PRs, docs externes ?

### Nom de fichier généré

```
{PRÉFIXE}{titre-slugifié}.md
```

Exemples :
- `PLAN_agents-claude-revue-pr.md`
- `CONTEXTE_migration-vm-2026-03.md`
- `rapport-audit-securite-vm.md`
- `PROPOSITION_workflow-morning-evening.md`
- `review-pr-1234.md`

Afficher le nom prévu et demander confirmation avant de créer.

### Structure générée

```markdown
# {Titre}

> Type : {type} · Date : YYYY-MM-DD
> Destination prévue : {Dossier vault} (via `/archive {nom-fichier}`)

## Contexte

{Réponse Q2}

## Contenu

{Réponse Q3}

## Références

{Réponse Q4}
```

### Destination

```
.claude/plans/{PRÉFIXE}{titre-slugifié}.md
```

---

## Mode 6 : Feature doc (vault direct)

Documentation d'une feature implémentée, créée directement dans le vault sans passer par `.claude/plans/`.

### Identifier le ticket

- Si `DP-XXXX` fourni en argument → utiliser cet ID
- Sinon → lire session en cours (`_ship-session.md` ou `_plan-session.md`)
- Si Linear MCP disponible → fetcher le titre du ticket

### Questions (séquentielles — une à la fois)

1. **Résumé** : En 1-2 phrases, qu'est-ce qui a été implémenté ?
2. **Fichiers modifiés** : Quels sont les fichiers principaux créés/modifiés ?
3. **Approche technique** : Comment ça a été implémenté ? Pourquoi cette approche ?
4. **Points d'attention** : Ce qui était délicat, les edge cases gérés, les compromis faits ?
5. **Tests** : Quels tests ont été ajoutés (RSpec, Cucumber) ?
6. **Lien PR** (optionnel) : URL de la PR ?

### Structure générée

```markdown
# [[DP-XXXX]] — {Titre du ticket}

> Date : YYYY-MM-DD · PR : {lien si fourni}

## Résumé

{Réponse Q1}

## Fichiers modifiés

{Réponse Q2}

## Approche technique

{Réponse Q3}

## Points d'attention

{Réponse Q4}

## Tests

{Réponse Q5}
```

### Destination

```
/Users/isalafont/code/BetaGouv/note_datapass/Tickets/YYYY-MM/DP-XXXX/implementation.md
```

Si le dossier `DP-XXXX` n'existe pas encore → le créer.

---

## Étape finale (tous modes)

Afficher le document généré et demander confirmation :

```
📄 {nom-fichier-prévu}
   → sera sauvegardé dans {chemin}
   → archivable via `/archive {nom-fichier}` vers {dossier vault}  ← (modes 1-5 seulement)

Aperçu :
{contenu généré}

Sauvegarder ? (oui / "Modifie: [détails]" / non)
```

Après sauvegarde :

```
✅ {nom-fichier} créé
📁 {chemin complet}
💡 Pour archiver vers le vault : /archive {nom-fichier}  ← (modes 1-5 seulement)
```
