# Stale Tickets

## 🎯 Quand utiliser cette commande

Identifier les tickets Linear assignés à Isabelle qui **traînent en `In Progress` ou `In Review`** depuis trop longtemps, pour proposer une action : reprise, archivage, ou réassignation.

Lancée manuellement à la demande, **ou automatiquement par `/morning` les lundis** (intégration dans la routine hebdo).

---

## 📋 Usage

```bash
/stale-tickets              # Seuil par défaut : 14 jours sans update
/stale-tickets --days 7     # Seuil personnalisé
```

---

## 🔄 Instructions

### 1. Fetcher les tickets d'Isabelle

Via MCP Linear, lister les tickets :
- Assignés à Isabelle (user ID `733836f2-a572-4acd-bd62-b70ce08c6421`)
- Statut : `In Progress` ou `In Review`
- Sans filtre d'équipe (DP et API)

### 2. Filtrer les stale

Pour chaque ticket, regarder le champ `updatedAt`. Garder uniquement ceux où `(now - updatedAt) > seuil` (défaut 14 jours).

### 3. Cross-check avec git et GitHub

Pour chaque ticket stale, vérifier :
- Existe-t-il une branche locale `dp-NNNN-*` ou `api-NNNN-*` ?
- Existe-t-il une PR ouverte (`gh pr list --search "DP-NNNN"`) ?
- Quel est le dernier commit sur la branche ?

### 4. Catégoriser

| Catégorie | Critère | Action proposée |
|---|---|---|
| 🟢 Reprise possible | branche locale + commits récents | « Reprendre le travail sur DP-XXXX ? » |
| 🟡 Bloqué externe | PR en review depuis > 7 jours | « Relancer le reviewer ? » |
| 🟠 Oublié | aucune branche / aucun commit récent | « Réassigner ou repasser en Todo ? » |
| 🔴 À archiver | code mergé mais ticket pas mis à jour | « `/cleanup-plans DP-XXXX` + passer en Done ? » |

### 5. Présenter la liste

Format compact, prêt à digérer en 30 sec :

```markdown
## 🕰 Stale Tickets — seuil {N} jours

| Ticket | Titre | Statut | Updated | Catégorie | Action proposée |
|---|---|---|---|---|---|
| [[DP-XXXX]] | Titre | In Progress | il y a 18j | 🟠 Oublié | Repasser en Todo ? |
| [[DP-YYYY]] | Titre | In Review | il y a 10j | 🟡 Bloqué | Relancer reviewer ? |
```

Si aucun ticket stale : afficher `✅ Pas de ticket stale au-delà du seuil de {N} jours.` et exit.

### 6. Pas d'action sans accord

❌ Ne **jamais** changer un statut Linear, créer une branche ou archiver un ticket sans accord explicite d'Isabelle.

---

## ⚠️ Règles

- ✅ Lecture seule par défaut
- ✅ Cross-check git+GitHub pour éviter les faux positifs (un ticket peut être "stale" sur Linear mais actif sur une branche)
- ❌ Pas de re-fetch si déjà lancé dans la session (cache résultat)

---

## 🔗 Commandes liées

- `/morning` (lundi) — invocation automatique
- `/cleanup-plans` — archiver un ticket terminé non mis à jour
- `/overview` — vue cross-projet incluant les tickets actifs
