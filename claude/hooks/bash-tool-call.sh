#!/bin/bash
# Hook pour auto-approuver les commandes de logs (lecture/écriture safe)
# Ce hook est appelé avant chaque commande Bash pour décider si elle nécessite confirmation
#
# Variables disponibles:
#   $COMMAND - La commande bash qui va être exécutée
#   $DESCRIPTION - La description de la commande
#
# Codes de sortie:
#   0 - Auto-approuver la commande
#   1 - Demander confirmation à l'utilisateur

# BLOQUER explicitement les commandes dangereuses
# Ces commandes nécessitent TOUJOURS une confirmation
if echo "$COMMAND" | grep -qE "(rm |delete |destroy |git |npm install|brew |pip install|sudo |chmod |chown )"; then
  exit 1  # Demander confirmation
fi

# AUTO-APPROUVER les commandes daily-log safe
# Permet: init, show, append, stats pour logs quotidiens et hebdomadaires
if echo "$COMMAND" | grep -qE "daily-log (log (init|show|append)|weekly (init|show)|stats)"; then
  exit 0  # Approuver
fi

# AUTO-APPROUVER les commandes routine (lecture seule + collecte données)
# morning: lit calendrier/tickets/logs
# evening: collecte données sans suppression
# weekly: génère stats
if echo "$COMMAND" | grep -qE "routine (morning|evening|weekly)"; then
  exit 0  # Approuver
fi

# AUTO-APPROUVER calendar-helper (lecture seule)
# today/week: affiche événements sans modification
if echo "$COMMAND" | grep -qE "calendar-helper.sh (today|week)"; then
  exit 0  # Approuver
fi

# AUTO-APPROUVER linear issue list (lecture seule)
# list: affiche tickets sans modification
if echo "$COMMAND" | grep -q "linear issue list"; then
  exit 0  # Approuver
fi

# AUTO-APPROUVER monthly-reminders (création événements calendrier)
# Création des rappels mensuels CRA + review
if echo "$COMMAND" | grep -q "monthly-reminders.sh"; then
  exit 0  # Approuver
fi

# AUTO-APPROUVER collect-daily-actions (collecte données journée)
# Collecte commits Git + activité Linear + notes travail
if echo "$COMMAND" | grep -q "collect-daily-actions"; then
  exit 0  # Approuver
fi

# Pour tout le reste : demander confirmation
# Principe de sécurité: par défaut, toujours demander
exit 1
