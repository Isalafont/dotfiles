# Archive Ticket Instructions

You are helping the user archive all files related to a specific ticket.

## Input

The user will provide:
1. **ticket_id** (required): The ticket identifier (e.g., "DP-1492", "dp-1492", "1492")
2. **description** (optional): A brief description of what the ticket was about

## Steps to follow

### 1. Parse and normalize the ticket ID

- Extract the ticket ID from the input
- Normalize it to lowercase for searching
- Handle various formats: "DP-1492", "dp-1492", "dp_1492", "1492"

### 2. Search for related files

Search in `.claude/plans/` for files matching these patterns:
- `{ticket-id}*.md` (e.g., `dp-1492-*.md`)
- `*{ticket-id}*.md` (e.g., `*-1492-*.md`)
- Use case-insensitive search
- Common patterns: `dp-1492`, `dp_1492`, `1492`

Use command like:
```bash
ls -1 .claude/plans/ | grep -iE "(dp[-_]?1492|1492)" | grep "\.md$"
```

### 3. Create archive directory

```bash
mkdir -p tmp/ai/{normalized-ticket-id}/
```

Use the original format provided by the user for the directory name (e.g., if they said "DP-1492", use `dp-1492`).

### 4. Move files

Move all found files to the archive directory:
```bash
mv .claude/plans/{file1} .claude/plans/{file2} ... tmp/ai/{ticket-id}/
```

### 5. Create README.md

Generate a comprehensive README with this structure:

```markdown
# {TICKET-ID} - {Brief Description}

## 🎯 Objectif

{Description of what the ticket was about}

## 📅 Timeline

- **Début** : {date from oldest file}
- **Completion** : {date from newest file}

## 📋 Fichiers archivés

### 1. {filename1} ({size})
{Brief description based on filename and content}

### 2. {filename2} ({size})
{Brief description based on filename and content}

...

## 📊 Métriques

- **Nombre de fichiers** : {count}
- **Taille totale** : {total size}
- **Documentation** : {total KB}

## 🔗 Commits / PR

{If you can detect commit IDs or PR references in the files, list them here}

## ✅ Status Final

{Based on file content, determine if completed, in progress, etc.}

## 📚 Tags

#{ticket-id} #archived #{additional-tags-based-on-content}

---

**Archivé le** : {current date}
```

### 6. Verify and report

After moving files:
- List the contents of the archive directory
- Confirm no files remain in `.claude/plans/` matching the pattern
- Provide a summary to the user

## Output format

Present the results in a clear, structured way:

```
✅ Ticket {TICKET-ID} archivé avec succès !

📁 Archive créée : tmp/ai/{ticket-id}/

📋 Fichiers déplacés ({count}) :
- {file1}
- {file2}
...

✅ Vérifications :
- Archive directory created
- {count} files moved
- README.md generated
- .claude/plans/ cleaned

📊 Résumé :
- Documentation : {size}
- Période : {date_range}
- Status : {final_status}
```

## Error handling

If no files found:
```
⚠️ Aucun fichier trouvé pour le ticket {TICKET-ID}

Patterns recherchés :
- {pattern1}
- {pattern2}

Suggestions :
- Vérifiez l'orthographe du ticket ID
- Vérifiez que les fichiers sont dans .claude/plans/
- Essayez avec un format différent (DP-1492 vs 1492)
```

## Important notes

- Always use `mv` (move) not `cp` (copy)
- Search case-insensitively
- Handle different naming conventions (dp-1492, dp_1492, 1492)
- Create a meaningful README even with minimal information
- Preserve file timestamps when moving
- Be conservative: if unsure if a file matches, ask the user

## Example invocations

**Simple:**
```
/archive-ticket DP-1492
```

**With description:**
```
/archive-ticket DP-1492 "Refactoring FranceConnect checkbox visibility"
```

**Just the number:**
```
/archive-ticket 1492
```