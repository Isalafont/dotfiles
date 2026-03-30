# Replan

## 🎯 Quand utiliser cette commande

Tu as **relu un plan à tête reposée**, ajouté tes réponses/annotations directement dans le fichier, et tu veux que Claude le réécrive en tenant compte de tes retours.

| Tu veux... | Commande |
|---|---|
| Créer un nouveau plan | `/plan` |
| Donner du feedback interactif sur un plan | Réponds directement en chat |
| **Réécrire un plan après l'avoir annoté offline** | **`/replan`** ← tu es ici |

---

## 📋 Usage

```bash
/replan .claude/plans/DP-1234-plan.md
```

---

## 🔄 Instructions

### 1. Lire le fichier

- Lire le fichier passé en argument dans son intégralité
- Identifier les réponses et annotations ajoutées en fin de fichier
- Repérer les lignes marquées `FIXME` (à traiter obligatoirement)

### 2. Évaluer l'ampleur des changements

**Si les changements sont mineurs** (précisions, reformulations) :
- Réécrire le plan en intégrant les retours
- Pas besoin de ré-explorer le codebase

**Si les changements sont majeurs** (approche différente, périmètre élargi) :
- Ré-explorer les parties du codebase concernées avant de réécrire
- Vérifier que le plan reste cohérent avec le code existant

### 3. Réécrire le plan

- Réécrire le plan **en place** (écraser le fichier existant)
- Intégrer tous les retours et réponses
- Traiter tous les `FIXME`
- Supprimer les annotations/questions résolues
- Conserver la structure du plan original

### 4. Questions restantes

Si des points restent flous après relecture :
- Les lister à la fin du plan sous `## ❓ Questions en suspens`
- Signaler explicitement qu'une réponse est attendue avant d'implémenter

---

## ⚠️ Règles

- ✅ Traiter tous les `FIXME` sans exception
- ✅ Réécrire le plan complet, pas juste patcher les sections modifiées
- ✅ Ré-explorer le codebase si l'approche change significativement
- ❌ Ne pas commencer à implémenter — réécrire le plan uniquement

---

## 🔗 Commandes liées

- `/plan` — Créer un plan depuis un ticket Linear
- `/ship` — Workflow complet ticket → PR
- `/implement-plan` — Implémenter un plan validé