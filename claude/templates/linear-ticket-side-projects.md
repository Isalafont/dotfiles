# Ticket Linear — side-projects

> ⛔ **Hors DataPass.** Ce canevas sert aux projets personnels (workspace Linear
> `linear-perso` : Tinder Immo, ImmoTracker, etc.).
>
> **Pour DataPass, ne jamais utiliser ce fichier.** L’équipe DataPass Produit (`DPP`) a
> cinq canevas typés — US, TS, Bug, Cadrage, Demande externe — qui vivent dans Linear et
> se lisent avec `get_template`. Voir le skill `create-linear-ticket`.
> Canevas : **constat métier d’abord, solution technique ensuite.** Rester court et lisible.

## Constat

Le problème vécu, côté métier / utilisateur / conformité. Ce qui se passe aujourd’hui, factuellement. 2 à 4 phrases. **Pas de solution ici.**

## Objectif

Ce qu’on veut obtenir, du point de vue de la valeur. 1 à 2 phrases.

## Proposition technique

Comment, en bref : approche, fichiers / composants clés, points d’attention (architecture, i18n, **accessibilité RGAA 4.1 AA**, sécurité). Synthétique — le détail fin va dans le plan, pas dans le ticket.

## Critères d’acceptation

Liste resserrée, chaque critère testable — idéalement « Étant donné … quand … alors … ».

1. …
2. …
3. Tests verts, linter propre, **RGAA 4.1 AA respecté**, doc à jour si nécessaire.

_(Tickets complexes uniquement — présenter les CA en tableau et formaliser des Règles de gestion (RG) à part. À n’utiliser que si le volume le justifie ; `&#10;` = saut de ligne en cellule.)_

| **CA** | **Description** | **État** |
| -- | -- | -- |
| CA-1 | [Critère en Gherkin] | ✅ OK &#10;❌ KO |

## Hors périmètre

- Ce qui n’est **pas** traité ici, et vers quel ticket ça renvoie.

---

**Méta** — Priorité : high / medium / low · Estimate : X pts · Labels : domain (`backend` / `frontend` / `accessibility` / …) + type · Dépendances : bloqué par / lié à CLA-XXXX · Références : plan `.claude/plans/…`, maquettes, docs.

## Format court Linear (copier-coller)

```
Titre: [Titre court]

## Constat
[Le problème métier, factuel — pas de solution]

## Objectif
[La valeur visée]

## Proposition technique
[Approche + fichiers clés]

## Critères d’acceptation
1. [CA-1]
2. [CA-2]
3. Tests verts, linter propre, RGAA 4.1 AA respecté.

## Hors périmètre
- [Ce qui n’est pas traité, → ticket]

Priorité: … · Estimate: … pts · Labels: … · Bloqué par / lié à: DP-XXXX
```
