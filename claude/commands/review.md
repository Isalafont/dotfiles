# Instructions pour les Reviews de Pull Requests

## Principes de review

- **Être franc et direct** : pas de langue de bois, dire clairement ce qui ne va pas
- **Be brutally honest** : if you think I'm wrong tell me
- **Challenger l'implémentation** : toujours se demander s'il existe une meilleure approche
- **Être constructif** : chaque critique doit être accompagnée d'une piste d'amélioration
- **Juger objectivement** : évaluer la PR sur sa qualité technique, pas sur l'effort fourni

---

## 1. Comprendre le contexte

- Lire le titre et la description de la PR
- Comprendre l'objectif fonctionnel
- Identifier les fichiers modifiés et le scope (models, controllers, views, services, tests)

## 2. Analyser les retours existants

- Récupérer la dernière review sur GitHub avec `gh pr view --comments` ou `gh pr reviews`
- Établir un plan exhaustif pour adresser chaque commentaire, un par un
- Pour chaque point soulevé, ajouter une question : **"À traiter ?"** pour validation
- Si des clarifications sont nécessaires, les lister à la fin du plan
- Écrire ce plan dans `.claude/plans/review-plan.md` (écraser si le fichier existe déjà)

## 3. Challenger l'implémentation

- **Remise en question** : l'approche choisie est-elle la plus adaptée ?
- **Alternatives** : existe-t-il une solution plus simple, plus performante ou plus maintenable ?
- **Over-engineering** : le code est-il trop complexe pour le besoin ?
- **Under-engineering** : manque-t-il une abstraction qui faciliterait l'évolution future ?
- **Cohérence** : l'implémentation suit-elle les patterns existants dans le projet ?
- **Trade-offs** : si l'approche a des compromis, sont-ils acceptables et documentés ?

## 4. Qualité du code

- **DRY** : vérifier l'absence de duplication
- **Extraction** : identifier les méthodes complexes à découper
- **Nommage** : s'assurer que les variables et méthodes ont des noms explicites
- **Gestion d'erreurs** : vérifier la présence de gestion appropriée des erreurs
- **Sécurité** : aucun secret, token ou credential exposé dans le code

## 5. Bonnes pratiques Rails

- **Controllers RESTful** : vérifier le respect des conventions REST
- **Autorisation** : s'assurer que l'autorisation est dans les controllers (pas dans les models/services)
- **Services/Organizers** : vérifier leur utilisation appropriée
- **Requêtes N+1** : détecter les problèmes de performance avec `includes`/`preload`
- **Scopes et callbacks** : vérifier leur bon usage

## 6. Tests

- **Couverture** : vérifier que le nouveau code est testé
- **Structure** : les tests doivent refléter la structure de l'application
- **Comportement** : tester le comportement métier, pas seulement les associations/validations
- **Non-régression** : si bugfix, vérifier la présence d'un test empêchant la régression

## 7. Documentation

- Vérifier si `docs/` nécessite une mise à jour
- S'assurer que la logique complexe est expliquée par des noms de méthodes clairs ou des commentaires

---

## Format de réponse

Structurer la review ainsi :

### 🎯 Verdict global
Une phrase directe sur la qualité de la PR : prête à merge, besoin de retouches mineures, ou refonte nécessaire.

### ✅ Points positifs
- Ce qui est bien fait

### 🔄 Alternatives à considérer
- Autres approches possibles avec leurs avantages/inconvénients

### ⚠️ Suggestions
- Améliorations non bloquantes

### 🚫 Bloquants
- Problèmes à corriger avant merge

### 📝 Questions
- Points à clarifier avec l'auteur

---

**Important** : Fournir des retours détaillés avec des références précises au format `fichier:numéro_de_ligne`. Ne pas hésiter à dire qu'une PR n'est pas prête si c'est le cas.
