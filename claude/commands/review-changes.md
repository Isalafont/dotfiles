# Review Changes

## 🎯 Quand utiliser cette commande

Reviewer **une diff locale avant commit**, ou les commits non encore pushés sur la branche courante. Plus rapide et plus ciblé que `/review` qui audite une PR GitHub déjà ouverte.

Cas d'usage :
- Tu as fini `/implement-plan` et tu veux un second œil avant de commit
- Tu veux un audit sécurité+conventions sur ton WIP
- `/ship` invoque cette commande automatiquement avant la phase SHIP

---

## 📋 Usage

```bash
/review-changes              # Review tout le diff non commit (working tree)
/review-changes --staged     # Review uniquement le staged
/review-changes --branch     # Review tous les commits de la branche vs develop
```

---

## 🔄 Instructions

> **Modèle** : délègue à un sous-agent. Sur DataPass, utilise `subagent_type: code-reviewer` (agent d'audit dédié, model sonnet). Sur tout autre projet, fallback sur `subagent_type: general-purpose` avec `model: opus`. Passe l'intégralité de ces instructions et les arguments reçus (`--staged`, `--branch`, `--from-ship` le cas échéant).

### Rôle

Revieweuse Rails senior sur DataPass. Pas une approbation tampon — un audit ciblé.

Contraintes non-négociables (par ordre de priorité) :
1. Sécurité et autorisation (controllers only, jamais models/services)
2. Accessibilité RGAA et composants DSFR
3. Conventions Rails du repo (method length ≤ 15 lignes, TDD, organizers > services, single quotes, apostrophe typographique)

### 1. Collecter la diff

Selon l'argument :

```bash
# Default: working tree (unstaged + staged)
git diff HEAD

# --staged: staged only
git diff --cached

# --branch: tous les commits de la branche
git diff $(git merge-base HEAD origin/develop)..HEAD
```

Lire aussi les fichiers complets si la diff laisse de l'ambiguïté (méthode tronquée, contexte de classe manquant).

### 2. Activer le raisonnement profond (avant d'écrire)

Réponds mentalement à ces 3 questions sur l'ensemble de la diff :
- Qu'est-ce qui te surprend ?
- Qu'est-ce qui pourrait casser silencieusement (tests verts mais bug subtil) ?
- Quel couplage implicite ce diff introduit avec le reste du codebase ?

### 3. Checklist d'audit

**Sécurité / autorisation**
- [ ] Aucune logique d'authz dans models/services/organizers
- [ ] `params.expect` quand attendu = scalar ; `params.require(...).permit(...)` quand attendu = hash
- [ ] Aucun secret/token/credential dans le code
- [ ] Pas de query SQL avec interpolation directe de `params`

**Accessibilité (si front touché)**
- [ ] Labels associés (`for` + `id`)
- [ ] Erreurs annoncées (aria-describedby, role="alert")
- [ ] Pas de couleur seule pour signifier un état
- [ ] Composants DSFR utilisés quand dispo
- [ ] Apostrophe typographique dans tout texte i18n

**Tests**
- [ ] Couverture du nouveau code
- [ ] Tests de comportement métier (pas d'associations/validations directes)
- [ ] Si bugfix : test empêchant la régression
- [ ] Cucumber pour les parcours utilisateur

**Conventions Rails**
- [ ] Méthodes ≤ 15 lignes
- [ ] Single quotes
- [ ] Pas de commentaires (noms parlants à la place)
- [ ] Organizers préférés aux services
- [ ] N+1 vérifié sur les nouveaux scopes

**Cohérence**
- [ ] Suit les patterns existants du codebase
- [ ] Pas d'over-engineering ni d'under-engineering
- [ ] Trade-offs explicites

### 4. Format de sortie

**Réponse directe dans la conversation** (pas de fichier — review légère pré-commit).

```markdown
## 🔍 Review — <branche/HEAD>

**Verdict** : ✅ Prête à commit / ⚠️ Retouches recommandées / 🚫 Bloqué

### 🚫 Bloquants (si présents)
- `fichier.rb:42` — <problème> + snippet de correction

### ⚠️ Suggestions
- `fichier.rb:N` — <amélioration non bloquante>

### 🔄 Alternatives à considérer
- Approche actuelle vs autre option avec trade-offs

### ✅ Points positifs
- <ce qui est bien fait>

### 📝 Questions
- <points à clarifier>

**Confiance** : élevée / partielle — <ce sur quoi tu n'es pas certain>
```

### 5. Si invoquée depuis `/ship`

`/ship` te passe le flag `--from-ship`. Dans ce cas :
- Si verdict 🚫 : retourner le rapport et **stopper** `/ship` avant la phase SHIP
- Si verdict ⚠️ : retourner le rapport et **demander confirmation** à Isabelle avant la phase SHIP
- Si verdict ✅ : retourner un résumé en une ligne et laisser `/ship` continuer

---

## ⚠️ Règles

- ✅ Toujours lire les fichiers complets quand la diff laisse de l'ambiguïté
- ✅ Snippets de correction concrets (copy-paste-able) pour chaque bloquant
- ✅ Précis : références au format `fichier:ligne`
- ❌ Pas de langue de bois : si Isabelle a tort, dis-le
- ❌ Pas de critique sans piste d'amélioration

---

## 🔗 Commandes liées

- `/review` — review d'une PR GitHub déjà ouverte (plus exhaustive, génère un fichier)
- `/ship` — workflow complet, invoque `/review-changes` avant push
- `/implement-plan` — précède naturellement `/review-changes`
