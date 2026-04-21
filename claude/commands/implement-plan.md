# Implement Plan

## Rôle

Tu exécutes un plan validé, pas un architecte qui l'améliore. Implémente exactement ce qui est écrit — ni plus, ni moins. Si le plan est ambigu ou incorrect sur un point, STOP et demande avant de continuer.

---

## 🎯 Quand utiliser cette commande

Tu as **déjà un plan validé** (généré par `/plan` ou écrit à la main) et tu veux juste le coder.

| Tu veux... | Commande |
|---|---|
| Juste préparer (pas coder aujourd'hui) | `/plan` |
| **Coder à partir d'un plan déjà validé** | **`/implement-plan`** ← tu es ici |
| Aller du ticket à la PR en une session | `/ship` |

---

## 📋 Usage

```bash
/implement-plan .claude/plans/DP-1234-plan.md
```

---

## 🔄 Instructions

### 1. Lire le plan

- Lire le fichier passé en argument
- Si le frontmatter référence un `context.md`, le lire également — il explique le pourquoi des étapes
- Identifier toutes les étapes d'implémentation
- Repérer les fichiers à modifier et les tests à écrire

### 2. Implémenter étape par étape

**Ordre obligatoire (CLAUDE.md) :**
1. Modèles + tests
2. Services/Organizers + tests
3. Controllers + vues
4. Features Cucumber

Lancer `bundle exec rubocop` **à la fin de chaque phase** (pas après chaque fichier).

**Pour chaque étape :**

1. Annoncer ce qu'on implémente :
   ```
   🔨 Étape X/N : [description]
   ```

2. Écrire le code

3. Lancer les tests ciblés :
   ```bash
   bundle exec rspec spec/path/to/file_spec.rb
   ```

4. **Corriger tout échec avant de passer à l'étape suivante**

6. Confirmer quand c'est bon :
   ```
   ✅ Étape X/N : done. Tests passent.
   ```

### 3. Gérer les problèmes

**Si un test échoue :**
- Analyser et corriger — ne pas sauter ni bypasser
- Ne jamais utiliser `--no-verify` ou contourner les hooks
- Si test flaky (aléatoire) : tenter de corriger, ne pas ajouter de `sleep`/`wait`

**Si un test non lié échoue :**
- Documenter dans le rapport final
- Continuer l'implémentation

**Si une étape est bloquée :**
- Documenter le blocage
- Demander guidance — ne pas improviser hors plan

### 4. Rapport final

En fin d'implémentation, produire un résumé :

```
✅ Implémentation terminée

Étapes complétées : X/N
Tests ajoutés : Y
Linter : ✅ clean

⚠️ Tests en échec non liés :
- spec/path/to/other_spec.rb : [raison]
```

---

## ⚠️ Règles critiques

- ✅ Suivre l'ordre CLAUDE.md (modèles → services → controllers → cucumber)
- ✅ Tester après chaque étape, corriger avant de continuer
- ✅ Rester strictement dans le périmètre du plan
- ❌ Ne pas implémenter tout puis tester à la fin
- ❌ Ne pas ajouter de `sleep`/`wait` dans les tests
- ❌ Ne pas bypasser les hooks git (`--no-verify`)
- ❌ Ne pas improviser des fonctionnalités hors plan
- ❌ Ne pas faire d'hypothèse sur une étape ambiguë — demander

---

## 🔗 Commandes liées

- `/plan` — Créer le plan avant d'implémenter
- `/ship` — Workflow complet ticket → PR
- `/deploy-check` — Validation complète avant de pousser
