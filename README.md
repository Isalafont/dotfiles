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

## Submodule `claude/marketplaces/rgaa-dev`

Le skill d'accessibilité vit dans son **propre dépôt** (`git@github.com:Isalafont/claude-skill-rgaa-dev.git`), déclaré ici comme **submodule git** (`.gitmodules`). Ce dépôt alimente le marketplace `rgaa-toolkit` (plugin `accessibility`).

> ⚠️ Il vit sous `claude/marketplaces/` (**pas** `claude/skills/`) volontairement : `claude/skills/` est symlinké vers `~/.claude/skills/`, où Claude Code scannerait son `.claude-plugin/` comme un plugin perso « accessibility » et entrerait en conflit avec le plugin installé du même nom.

Conséquence : `dotfiles` ne stocke pas le contenu du skill, seulement un **pointeur de commit** (gitlink). Le mettre à jour se fait **en deux temps** :

```bash
# 1. Dans le sous-repo : modifier, commit, push
cd claude/marketplaces/rgaa-dev
# … éditer …
git commit -am "…" && git push

# 2. Dans dotfiles : enregistrer le nouveau pointeur
cd -
git add claude/marketplaces/rgaa-dev
git commit -m "Pointe rgaa-dev sur <version>"
```

Un `git status` qui montre `M claude/marketplaces/rgaa-dev` signifie seulement que le pointeur est en retard sur le HEAD du sous-repo — pas que des fichiers de `dotfiles` ont changé. Un hook `post-commit` (versionné dans le submodule, posé par son `install.sh`) automatise l'étape 2.

Cloner `dotfiles` à neuf : `git clone --recurse-submodules`, ou après coup `git submodule update --init`.

---

_Dernière mise à jour : 2026-06-15._
