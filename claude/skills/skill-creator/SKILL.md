---
name: skill-creator
description: Create a new Claude Code skill following Anthropic's official standards and best practices
argument-hint: [skill-name] [skill-type]
allowed-tools: Read, Write, Bash(mkdir *)
---

# Skill Creator

Crée un nouveau skill Claude Code conforme aux standards officiels Anthropic.

## Quand Utiliser ce Skill

**✅ Utiliser quand :**
- Besoin de créer un nouveau skill
- Convertir des instructions en skill structuré
- Refactoriser un skill existant
- Garantir conformité aux standards Anthropic

## Arguments

- **$0 (skill-name)** : Nom du skill en kebab-case (ex: `deploy-app`, `review-pr`)
- **$1 (skill-type)** : Type de skill (optionnel)
  - `task` : Skill d'action (ex: déploiement, création)
  - `reference` : Skill de connaissance passive (ex: conventions, standards)
  - `wizard` : Skill interactif guidé (ex: formulaires)

## Workflow de Création

### 1. Déterminer l'Emplacement

**Personnel (recommandé pour skills réutilisables) :**
```
~/.claude/skills/<skill-name>/
```

**Projet (pour skills spécifiques) :**
```
.claude/skills/<skill-name>/
```

### 2. Structure du Skill

Le skill créera automatiquement :

```
<skill-name>/
├── SKILL.md              # Fichier principal (<500 lignes)
├── reference.md          # Documentation détaillée (optionnel)
├── examples.md           # Exemples d'utilisation (optionnel)
├── templates/            # Templates de fichiers (optionnel)
└── README.md             # Documentation du skill
```

### 3. Frontmatter YAML Requis

Chaque SKILL.md doit commencer par :

```yaml
---
name: skill-name                      # Identifiant unique
description: What this skill does    # Pour que Claude sache quand l'utiliser
---
```

### 4. Champs Frontmatter Optionnels

| Champ | Utilité | Exemple |
|-------|---------|---------|
| `argument-hint` | Aide pour arguments | `[file] [format]` |
| `disable-model-invocation` | Seul user peut invoquer | `true` |
| `user-invocable` | Seul Claude peut invoquer | `false` |
| `allowed-tools` | Outils sans permission | `[Read, Grep, Bash(gh *)]` |
| `model` | Modèle spécifique | `claude-opus-4-5` |
| `context` | Exécuter en subagent | `fork` |
| `agent` | Type de subagent | `Explore`, `Plan` |

### 5. Bonnes Pratiques

**Structure du Contenu :**
1. **Overview** : Explication rapide (1-2 phrases)
2. **When to use** : Cas d'usage clairs
3. **Instructions** : Étapes ou référence
4. **Examples** : Exemples concrets (dans examples.md si nombreux)
5. **Resources** : Liens vers fichiers supports

**Règles :**
- SKILL.md < 500 lignes (diviser si plus long)
- Utiliser Markdown structuré (h2, h3, listes)
- Code blocks avec langage spécifié
- Liens relatifs vers fichiers supports

### 6. Substitutions de Variables

Utilisables dans le skill :

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | Tous les arguments |
| `$0`, `$1`, `$N` | Argument par index |
| `${CLAUDE_SESSION_ID}` | ID de session unique |

**Exemple :**
```markdown
Deploy $0 to $1 environment:
1. Build application
2. Run tests
3. Deploy to $1
```

### 7. Checklist de Validation

Avant de finaliser, vérifier :

- [ ] Frontmatter YAML présent avec `name` et `description`
- [ ] SKILL.md < 500 lignes
- [ ] Description claire pour que Claude sache quand l'utiliser
- [ ] Structure Markdown cohérente (titres, listes)
- [ ] Exemples concrets inclus
- [ ] Fichiers supports si SKILL.md trop long
- [ ] README.md créé pour documentation

## Exemples de Skills

### Skill Task (Action)

```yaml
---
name: deploy-app
description: Deploy application to production environment
argument-hint: [environment]
disable-model-invocation: true
context: fork
agent: Plan
---

# Deploy Application

Deploy $ARGUMENTS to production.

## Steps
1. Run test suite
2. Build application
3. Deploy to environment
4. Verify deployment
```

### Skill Reference (Connaissance)

```yaml
---
name: api-conventions
description: API design patterns and standards for this project
user-invocable: false
---

# API Conventions

When designing API endpoints:
- Use RESTful naming
- Validate all input
- Include error handling
- Document with OpenAPI
```

### Skill Wizard (Interactif)

```yaml
---
name: component-creation
description: Create a new UI component following project standards
argument-hint: [component-type] [component-name]
allowed-tools: Read, Write, Edit
---

# Component Creation Wizard

Create a new component: $0 named $1

## Steps
1. Choose component type
2. Generate boilerplate
3. Add tests
4. Create documentation
```

## Ressources

Pour plus de détails, consulter :
- **Documentation complète** : `~/assistant/systeme/claude-skills/`
- **Standards Anthropic** : `~/assistant/systeme/claude-skills/standards.md`
- **Templates** : `~/.claude/skills/skill-creator/templates/`
- **Checklists** : `~/.claude/skills/skill-creator/checklists/`

## Références Officielles

- **Documentation Skills** : https://code.claude.com/docs/en/skills.md
- **Subagents** : https://code.claude.com/docs/en/sub-agents.md
- **Permissions** : https://code.claude.com/docs/en/iam.md
