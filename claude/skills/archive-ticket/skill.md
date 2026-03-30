# Archive Ticket Skill

Archive all files related to a specific ticket into tmp/ai/ directory.

## Usage

```bash
/archive-ticket DP-1492
```

Or with optional description:

```bash
/archive-ticket DP-1492 "Refactoring FranceConnect checkbox"
```

## What it does

1. Searches for all files matching the ticket pattern in `.claude/plans/`
2. Creates a directory `tmp/ai/{ticket-id}/`
3. Moves all matching files to the archive directory
4. Creates a comprehensive README.md with:
   - Ticket overview
   - File listing with descriptions
   - Timeline
   - Final status
   - Metrics

## File patterns searched

The skill searches for files matching these patterns:
- `{ticket-id}*.md`
- `*{ticket-id}*.md`
- Case-insensitive matching

Examples for DP-1492:
- `dp-1492-*.md`
- `dp_1492_*.md`
- `*1492*.md`

## Archive structure

```
tmp/ai/{ticket-id}/
├── README.md
├── {original-file-1}.md
├── {original-file-2}.md
└── ...
```

## Benefits

- ✅ Keeps `.claude/plans/` clean
- ✅ Centralizes ticket documentation
- ✅ Easy to find all related files
- ✅ Preserves history and context
- ✅ Facilitates sharing and archiving