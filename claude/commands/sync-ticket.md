# Sync Ticket

## 🎯 Quand utiliser cette commande

Importer/rafraîchir les **commentaires Linear** d'un ticket dans sa note vault Obsidian, pour avoir l'historique complet offline et la traçabilité dans la knowledge base perso.

Cas d'usage :
- Tu reprends un ticket après un break — récupérer la conversation Linear
- Avant un archivage, fixer le contexte sous forme de note
- Brief pour quelqu'un d'autre (mode lecture offline)

---

## 📋 Usage

```bash
/sync-ticket DP-1234        # Pull commentaires Linear → note vault
/sync-ticket API-6735       # Idem pour un ticket API Parteprise
```

---

## 🔄 Instructions

### 1. Identifier l'équipe et fetcher le ticket Linear

Le préfixe du `TICKET-ID` détermine l'équipe :
- `DP-NNNN` → équipe **DataPass**
- `API-NNNN` → équipe **API Parteprise**

Via MCP Linear (`mcp__linear-server__get_issue`), récupérer :
- Titre, description, statut, priorité, labels
- Cycle, estimate
- L'équipe (pour confirmer le préfixe)
- Liste des commentaires (`mcp__linear-server__list_comments`)
- Auteur et date de chaque commentaire

### 2. Localiser la note vault

Le vault range les tickets DP et API **dans le même dossier** `Tickets/`, sans sous-dossier par projet. La distinction se fait via le frontmatter (`team:` + le préfixe de l'ID).

Recherche multi-format (le vault a plusieurs conventions historiques) :

1. `~/code/BetaGouv/note_datapass/Tickets/YYYY-MM/{TICKET-ID}/index.md` (format dossier, **préféré**)
2. `~/code/BetaGouv/note_datapass/Tickets/YYYY-MM/{TICKET-ID}.md` (format flat mensuel)
3. `~/code/BetaGouv/note_datapass/Tickets/{TICKET-ID}.md` (format flat racine, legacy)

Si **aucune** trouvée : créer au format préféré (1) avec `YYYY-MM` dérivé de la date de création du ticket Linear.

Frontmatter minimal :

```markdown
---
ticket: {TICKET-ID}
team: {DataPass|API Parteprise}  # déduit du préfixe DP/API
title: {titre}
status: {statut}
priority: {priorité}
cycle: {cycle}
linear_url: https://linear.app/...
synced_at: YYYY-MM-DDTHH:MM:SSZ
---

# {TICKET-ID} — {titre}

## 📋 Description Linear

{description}

## 💬 Commentaires Linear

{section gérée par /sync-ticket — voir ci-dessous}
```

❌ Ne **jamais** créer ailleurs que sous `Tickets/` (refuser tout autre path).
❌ Ne pas créer de sous-dossier par équipe — la convention vault actuelle est plate.

### 3. Synchroniser les commentaires

Sous la section `## 💬 Commentaires Linear`, écrire (en mode **append idempotent**) :

```markdown
### {auteur} — YYYY-MM-DD HH:MM

{contenu commentaire}

---
```

**Idempotence** : avant d'ajouter un commentaire, vérifier qu'une entrée avec la même date+auteur n'existe pas déjà. Si oui, **skip** (pas de dédup partiel — soit le commentaire est déjà là, soit pas).

### 4. Mettre à jour le frontmatter

- `status` : statut courant Linear
- `priority` : priorité courante
- `synced_at` : timestamp ISO 8601 du moment du sync

### 5. Résumé à Isabelle

```
✅ Sync DP-XXXX → ~/code/BetaGouv/note_datapass/Tickets/YYYY-MM/DP-XXXX/index.md
   • N nouveaux commentaires ajoutés
   • Statut : {statut}
```

---

## ⚠️ Règles

- ✅ Append idempotent (ne pas re-écrire un commentaire déjà sync)
- ✅ Préserver les sections vault propres (Sessions de travail, Décisions, etc.) — ne toucher qu'à `## 💬 Commentaires Linear` et au frontmatter
- ❌ Ne pas créer la note si elle n'est pas dans `Tickets/` (refuser de créer ailleurs)
- ❌ Ne pas archiver — c'est le rôle de `/cleanup-plans`

---

## 🔗 Commandes liées

- `/cleanup-plans {TICKET-ID}` — archive complète (copie `.claude/plans/` + index, ne pull pas les commentaires Linear)
- `/stale-tickets` — identifie les tickets qui mériteraient un sync avant archive
