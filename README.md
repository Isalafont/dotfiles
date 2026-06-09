# Dotfiles — cartographie des dépôts

J'ai **trois** dossiers `dotfiles` sous `~/code/Isalafont/`. Deux partagent le **même** remote GitHub, ce qui prête à confusion. Ce fichier dit lequel est lequel et lequel alimente réellement `~/.claude`.

## `dotfiles` — public, actif ✅

- **Remote** : `git@github.com:Isalafont/dotfiles.git`
- **Branche** : `main`
- **Rôle** : c'est **ce dépôt-ci**, le seul réellement utilisé.

Tout `~/.claude` est symlinké vers `dotfiles/claude/` :

| `~/.claude/…` | → cible |
|---|---|
| `settings.json` | `dotfiles/claude/settings.json` |
| `hooks/` | `dotfiles/claude/hooks/` |
| `skills/` | `dotfiles/claude/skills/` |
| `agents/` | `dotfiles/claude/agents/` |
| `commands/` | `dotfiles/claude/commands/` |
| `CLAUDE.md` | `dotfiles/claude/CLAUDE.md` |

➡️ **Toute modif de config Claude (hooks, skills, settings, agents) se commit ICI.**

> ⚠️ `~/.claude/settings.json` est un **symlink**. Toujours éditer la cible réelle `dotfiles/claude/settings.json` — un outil qui refuse d'écrire à travers le symlink doit viser ce chemin.

## `dotfiles-private` — privé 🔒

- **Remote** : `git@github.com:Isalafont/dotfiles-private.git` (dépôt **distinct**, privé)
- **Branche** : `main`
- **Contenu** : `secrets/`, `config/`, et côté claude `memory-datapass` + `backup-memory.sh` / `restore-memory.sh`.
- **Rôle** : coffre pour les données sensibles et la **sauvegarde de la memory** (par scripts, **pas** par symlink). Aucune entrée de `~/.claude` ne pointe dessus.

## `dotfiles-lewagon` — doublon legacy ⚠️

- **Remote** : **identique** à `dotfiles` (`git@github.com:Isalafont/dotfiles.git`)
- **Branche** : `master` (legacy Le Wagon)
- **Rôle** : second clone **dormant** du dépôt public, **non branché** sur `~/.claude`.

> ❌ Ne jamais y travailler, ni push `master` : risque de divergence sur le **même** dépôt GitHub que `dotfiles`. **Candidat à archiver/supprimer** une fois vérifié qu'il ne contient rien d'unique.

---

_Dernière mise à jour : 2026-06-09._
