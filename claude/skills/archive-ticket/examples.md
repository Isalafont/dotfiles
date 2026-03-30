# Archive Ticket - Examples

## Example 1: Archive DP-1492 (Complete workflow)

**Command:**
```
/archive-ticket DP-1492
```

**What happens:**

1. **Search phase:**
   ```
   Recherche de fichiers pour DP-1492...

   Fichiers trouvés dans .claude/plans/:
   - dp-1492-alternative-connexion.md
   - dp-1492-fix-fc-alternative-connexion.md
   - review_dp_1492.md
   - dp_1492_architectural_review_and_refactoring_plan.md
   ```

2. **Archive creation:**
   ```
   Création de tmp/ai/dp-1492/...
   Déplacement de 4 fichiers...
   Génération du README.md...
   ```

3. **Result:**
   ```
   ✅ Ticket DP-1492 archivé avec succès !

   📁 tmp/ai/dp-1492/
   ├── README.md (3K)
   ├── dp-1492-alternative-connexion.md (961B)
   ├── dp-1492-fix-fc-alternative-connexion.md (13K)
   ├── review_dp_1492.md (15K)
   └── dp_1492_architectural_review_and_refactoring_plan.md (21K)

   ✅ .claude/plans/ nettoyé (0 fichiers DP-1492 restants)
   ```

## Example 2: With description

**Command:**
```
/archive-ticket DP-1484 "Bug fix: too many redirects on volumetrie"
```

**Result:**
The README will include the provided description as the objective.

## Example 3: Just the number

**Command:**
```
/archive-ticket 1498
```

**What happens:**
- Searches for patterns: `1498`, `dp-1498`, `dp_1498`, etc.
- Creates directory: `tmp/ai/1498/`

## Example 4: No files found

**Command:**
```
/archive-ticket DP-9999
```

**Result:**
```
⚠️ Aucun fichier trouvé pour le ticket DP-9999

Patterns recherchés :
- dp-9999*.md
- dp_9999*.md
- *9999*.md

Voulez-vous :
1. Réessayer avec un autre format
2. Vérifier le numéro de ticket
3. Chercher dans un autre répertoire
```

## Example 5: Partial match confirmation

**Command:**
```
/archive-ticket 149
```

**What happens:**
```
⚠️ Plusieurs tickets correspondent :
- DP-1492 (4 fichiers)
- DP-1498 (2 fichiers)
- DP-1490 (3 fichiers)

Lequel voulez-vous archiver ?
```

## Common use cases

### After completing a ticket
```bash
/archive-ticket DP-1492
```

### Before starting a new ticket (cleanup)
```bash
/archive-ticket DP-1484
```

### Batch archiving (not yet supported, manual)
```bash
/archive-ticket DP-1492
/archive-ticket DP-1484
/archive-ticket DP-1498
```

### Check what would be archived (future feature)
```bash
/archive-ticket DP-1492 --dry-run
```

## Tips

1. **Always archive after completing a ticket** - keeps `.claude/plans/` clean
2. **Include a description** - makes README more useful
3. **Check the archive** - verify all files are there
4. **Commit the archive** - preserve in git if needed
5. **Share easily** - `tmp/ai/ticket-id/` is self-contained