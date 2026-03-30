# Skill Creator

Skill pour créer de nouveaux skills Claude Code conformes aux standards officiels Anthropic.

## Structure du Skill

```
skill-creator/
├── SKILL.md              # Instructions principales
├── templates/            # Templates de fichiers
│   ├── SKILL.md.template
│   ├── reference.md.template
│   ├── examples.md.template
│   └── README.md.template
├── checklists/           # Checklists de validation
│   └── conformity.md
└── README.md             # Ce fichier
```

## Utilisation

### Invocation par l'Utilisateur

```bash
# Créer un skill task
/skill-creator deploy-app task

# Créer un skill reference
/skill-creator api-conventions reference

# Créer un skill wizard
/skill-creator component-creation wizard
```

### Invocation Automatique par Claude

Claude invoque automatiquement ce skill quand :
- L'utilisateur demande de créer un nouveau skill
- Il faut refactoriser un skill existant
- Besoin de garantir conformité aux standards

## Fichiers

### SKILL.md
Instructions principales pour créer un skill, avec workflow complet et exemples.

### templates/
Templates de fichiers prêts à l'emploi :
- `SKILL.md.template` : Template principal avec frontmatter
- `reference.md.template` : Documentation détaillée
- `examples.md.template` : Exemples d'utilisation
- `README.md.template` : Documentation du skill

Chaque template contient des placeholders `{{VARIABLE}}` à remplacer.

### checklists/
Checklists de validation :
- `conformity.md` : Checklist complète de conformité aux standards

## Types de Skills

### Task (Action)
Skill qui exécute des tâches concrètes.

**Caractéristiques :**
- `disable-model-invocation: true` (seul user peut invoquer)
- `context: fork` (exécution en subagent)
- Instructions étape par étape

**Exemples :** deploy-app, create-component, run-tests

### Reference (Connaissance)
Skill de connaissance passive, consulté par Claude.

**Caractéristiques :**
- `user-invocable: false` (seul Claude peut invoquer)
- Contenu toujours disponible dans le contexte
- Documentation et standards

**Exemples :** api-conventions, code-style, architecture-patterns

### Wizard (Interactif)
Skill qui guide l'utilisateur étape par étape.

**Caractéristiques :**
- Arguments pour personnalisation
- Instructions interactives
- Validation à chaque étape

**Exemples :** component-creation, setup-project, configure-deploy

## Workflow de Création

1. **Déterminer le type** : task, reference, ou wizard
2. **Choisir l'emplacement** : `~/.claude/skills/` (global) ou `.claude/skills/` (projet)
3. **Créer la structure** : utiliser les templates
4. **Remplir le contenu** : frontmatter + instructions
5. **Valider** : utiliser checklist de conformité
6. **Tester** : invoquer le skill et vérifier comportement

## Métadonnées

- **name**: `skill-creator`
- **description**: Create a new Claude Code skill following Anthropic's official standards and best practices
- **argument-hint**: `[skill-name] [skill-type]`
- **allowed-tools**: `Read, Write, Bash(mkdir *)`

## Conformité Standards Anthropic

✅ Ce skill respecte les recommandations officielles :
- Frontmatter YAML avec métadonnées
- SKILL.md < 500 lignes
- Templates réutilisables
- Checklists de validation
- Documentation complète

## Ressources Complémentaires

Pour une documentation complète sur les skills :
- **Documentation détaillée** : `~/assistant/systeme/claude-skills/`
- **Standards Anthropic** : `~/assistant/systeme/claude-skills/standards.md`
- **Exemples** : `~/assistant/systeme/claude-skills/examples/`

## Références Officielles

- **Documentation Skills** : https://code.claude.com/docs/en/skills.md
- **Subagents** : https://code.claude.com/docs/en/sub-agents.md
- **Permissions** : https://code.claude.com/docs/en/iam.md

---

**Dernière mise à jour** : 29 janvier 2026
