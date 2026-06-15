# Checklist de Conformité - Skills Claude Code

Vérifier ces points avant de finaliser un skill.

## ✅ Structure de Fichiers

- [ ] Dossier créé : `~/.claude/skills/<skill-name>/` ou `.claude/skills/<skill-name>/`
- [ ] Fichier principal : `SKILL.md` présent
- [ ] README.md créé pour documentation
- [ ] Fichiers supports créés si nécessaire (reference.md, examples.md)
- [ ] Templates dans dossier `templates/` si applicable

## ✅ Frontmatter YAML

### Champs Obligatoires

- [ ] `name` : Identifiant en kebab-case (max 64 caractères)
- [ ] `description` : Description claire pour que Claude sache quand l'utiliser

### Champs Optionnels (si pertinent)

- [ ] `argument-hint` : Si le skill accepte des arguments
- [ ] `disable-model-invocation` : Si seul l'utilisateur peut l'invoquer
- [ ] `user-invocable` : Si seul Claude peut l'invoquer
- [ ] `allowed-tools` : Liste des outils autorisés
- [ ] `model` : Si un modèle spécifique est requis
- [ ] `context` : Si exécution en subagent (`fork`)
- [ ] `agent` : Type de subagent (`Explore`, `Plan`, `general-purpose`)

## ✅ Contenu SKILL.md

### Taille et Structure

- [ ] Moins de 500 lignes (diviser en fichiers si plus long)
- [ ] Titres hiérarchiques (h2, h3) cohérents
- [ ] Pas de h1 (généré automatiquement par le frontmatter)

### Sections Essentielles

- [ ] **Overview** : Explication rapide (1-2 phrases)
- [ ] **When to use** : Cas d'usage clairs
- [ ] **Instructions** : Étapes détaillées ou référence
- [ ] **Examples** : Au moins 1 exemple concret
- [ ] **Resources** : Liens vers fichiers supports si applicable

### Format Markdown

- [ ] Code blocks avec langage spécifié (\`\`\`bash, \`\`\`ruby, etc.)
- [ ] Listes à puces pour options
- [ ] Listes numérotées pour étapes séquentielles
- [ ] Liens relatifs vers fichiers supports
- [ ] Tableaux pour données structurées

## ✅ Description

- [ ] Claire et spécifique (pas trop générique)
- [ ] Indique QUAND utiliser le skill
- [ ] Mentionne le contexte ou domaine
- [ ] Permet à Claude de décider si pertinent

### Exemples de Bonnes Descriptions

✅ "Create ViewComponents following Atomic Design, DSFR standards, and RGAA accessibility for DataPass"
✅ "Deploy application to production environment with health checks and rollback"
✅ "Perform RGAA accessibility audit on a website and generate conformity report"

### Exemples de Mauvaises Descriptions

❌ "Help with components" (trop vague)
❌ "Create things" (pas spécifique)
❌ "Do stuff" (inutile)

## ✅ Arguments

Si le skill accepte des arguments :

- [ ] `argument-hint` défini dans frontmatter
- [ ] Utilisation de `$ARGUMENTS`, `$0`, `$1`, etc. dans le contenu
- [ ] Arguments documentés dans SKILL.md
- [ ] Exemples d'utilisation avec arguments

## ✅ Permissions

Si le skill utilise des outils :

- [ ] `allowed-tools` spécifié dans frontmatter
- [ ] Syntaxe correcte : `[Read, Grep, Bash(gh *)]`
- [ ] Wildcards appropriés pour Bash (ex: `Bash(git *)`)
- [ ] Outils minimaux nécessaires (pas de sur-permission)

## ✅ Subagents

Si le skill utilise un subagent :

- [ ] `context: fork` défini
- [ ] `agent` spécifié (`Explore`, `Plan`, `general-purpose`)
- [ ] `allowed-tools` défini pour le subagent
- [ ] Instructions claires pour le subagent

## ✅ Fichiers Supports

### reference.md

- [ ] Créé si SKILL.md > 400 lignes
- [ ] Contient documentation technique détaillée
- [ ] Référencé depuis SKILL.md
- [ ] Structure claire avec sections

### examples.md

- [ ] Créé si plus de 2-3 exemples
- [ ] Exemples concrets et testables
- [ ] Explications pour chaque exemple
- [ ] Anti-patterns si pertinent

### templates/

- [ ] Créé si le skill génère des fichiers
- [ ] Templates avec placeholders `{{VARIABLE}}`
- [ ] Un template par type de fichier
- [ ] Documentation des placeholders

## ✅ Qualité du Contenu

- [ ] Pas de typos ou fautes d'orthographe
- [ ] Langage clair et concis
- [ ] Ton professionnel et objectif
- [ ] Éviter jargon sans explication
- [ ] Français ou anglais cohérent (pas de mix)

## ✅ Accessibilité et Maintenabilité

- [ ] Noms de variables/placeholders explicites
- [ ] Exemples réalistes (pas de foo/bar excessif)
- [ ] Code formaté et indenté
- [ ] Commentaires dans le code si nécessaire
- [ ] Liens externes valides

## ✅ Testing

- [ ] Skill invocable : `/skill-name` fonctionne
- [ ] Arguments parsés correctement
- [ ] Instructions claires et non ambiguës
- [ ] Claude comprend quand l'invoquer
- [ ] Pas de conflit avec autres skills

## ✅ Documentation

- [ ] README.md créé
- [ ] Structure du skill documentée
- [ ] Cas d'usage documentés
- [ ] Métadonnées listées
- [ ] Date de dernière mise à jour

## ✅ Conformité Anthropic

- [ ] Respecte les standards officiels
- [ ] Pas de fonctionnalités non documentées
- [ ] Suit les best practices
- [ ] Compatible avec Claude Code

---

## Score de Conformité

**Total de cases cochées : _____ / _____**

- **90-100%** : ✅ Excellent - Prêt pour utilisation
- **70-89%** : ⚠️ Bon - Quelques améliorations mineures
- **50-69%** : 🔶 Moyen - Améliorations nécessaires
- **< 50%** : ❌ Faible - Refactorisation majeure requise

---

**Date de vérification** : _______________
**Vérifié par** : _______________
