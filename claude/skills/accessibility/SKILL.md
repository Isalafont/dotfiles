---
name: accessibility
description: Guide d'implémentation accessibilité numérique selon RGAA 4.1, WCAG 2.1 et patterns ARIA. Référence pour auditer, corriger ou implémenter du code accessible. Invoquer quand on crée ou modifie des composants HTML, des formulaires, des liens, de la navigation, ou quand on parle d'accessibilité, RGAA, WCAG, ARIA, handicap.
---

# Accessibilité Numérique — Guide RGAA / WCAG / ARIA

> **Versions couvertes** : RGAA 4.1 · WCAG 2.1 (AA) · DSFR 1.x · WAI-ARIA 1.2
> **Dernière mise à jour** : mars 2026

---

## Quel fichier lire selon la tâche

| Tâche | Fichiers à consulter |
|-------|----------------------|
| Créer/modifier un formulaire | SKILL.md §Formulaires + [examples-dsfr.md](examples-dsfr.md) §Formulaires + [rails-patterns.md](rails-patterns.md) §DSFRFormBuilder |
| Créer un composant interactif (modale, onglets, accordéon) | [examples-dsfr.md](examples-dsfr.md) + [examples-html.md](examples-html.md) §ARIA + [rails-patterns.md](rails-patterns.md) §Stimulus |
| Créer/modifier de la navigation ou des liens | SKILL.md §Navigation + [examples-dsfr.md](examples-dsfr.md) §Liens et Navigation |
| Auditer ou faire la review d'une page | [checklist.md](checklist.md) du type de page + [html-structure.md](html-structure.md) §Outils |
| Travailler avec Turbo / Hotwire | [rails-patterns.md](rails-patterns.md) §Turbo |
| Question sur contrastes ou couleurs | [colors.md](colors.md) |
| Question sur upload de fichiers | SKILL.md §Upload + [rails-patterns.md](rails-patterns.md) |
| Comprendre l'impact d'un défaut sur les utilisateurs | [impacts.md](impacts.md) |
| Trouver un outil ou une ressource | [resources.md](resources.md) |

## Workflow quotidien — accessibility-first

Applique l'accessibilité **pendant** l'implémentation, pas après :

1. **Structure HTML sémantique d'abord** — titres, landmarks, listes, éléments natifs
2. **Attributs ARIA sur les éléments interactifs** — `aria-expanded`, `aria-controls`, labels
3. **Checklist du type de page** avant le commit — [checklist.md](checklist.md)
4. **Test clavier rapide** — Tab, Shift+Tab, Enter, Escape, flèches dans les composants
5. **Test zoom 200%** — `Cmd++` × 6, vérifier qu'aucun contenu n'est coupé
6. **axe-core en CI** — les steps Cucumber `Then la page est accessible` détectent les regressions

---

## Contexte

Le **RGAA 4.1** (Référentiel Général d'Amélioration de l'Accessibilité) est le standard légal français,
basé sur les **WCAG 2.1** du W3C. Il s'applique à tous les services publics numériques.

Non-conformité = exclusion réelle de personnes en situation de handicap :
- Cécité / malvoyance → lecteurs d'écran (NVDA, JAWS, VoiceOver)
- Motricité réduite → navigation clavier uniquement
- Surdité → sous-titres, transcriptions
- Troubles cognitifs → clarté, structure, prévisibilité

**Ressource impacts utilisateurs** : https://ideance-a11y.github.io/rgaa4-impacts-utilisateurs/

---

## Règles d'or (à appliquer systématiquement)

1. **Tout élément interactif est accessible au clavier** (Tab, Enter, Espace, flèches)
2. **Tout contenu non-textuel a un équivalent textuel** (`alt`, `aria-label`, `aria-labelledby`)
3. **Le focus est toujours visible** (ne jamais faire `outline: none` sans alternative)
4. **Les couleurs ne sont pas le seul vecteur d'information** (contraste minimum 4.5:1)
5. **La structure sémantique est correcte** (titres hiérarchiques, landmarks, listes)
6. **Les formulaires sont labellisés** (`<label for>` ou `aria-labelledby`)
7. **Les erreurs sont identifiées** et suggèrent une correction
8. **Le contenu peut être agrandi à 200%** sans perte d'information (RGAA 10.4) — tester avec `Cmd++` × 6 dans le navigateur : aucun texte coupé, aucun scroll horizontal, tous les composants fonctionnels

---

## Thèmes RGAA — Critères essentiels

### 1. Images (Thème 1)
```html
<!-- Image porteuse de sens -->
<img src="logo.png" alt="DataPass — Gestion des habilitations">

<!-- Image décorative : alt="" suffit, role="presentation" est inutile -->
<img src="decoration.png" alt="">

<!-- Image-lien -->
<a href="/accueil">
  <img src="logo.png" alt="DataPass — Retour à l'accueil">
</a>

<!-- SVG accessible -->
<svg aria-hidden="true" focusable="false">...</svg>
<svg role="img" aria-label="Description du graphique">
  <title>Description du graphique</title>
</svg>
```

### 2. Couleurs (Thème 3)
- Contraste texte normal : **≥ 4.5:1**
- Contraste grand texte (≥ 18pt ou 14pt gras) : **≥ 3:1**
- Contraste composants UI (boutons, champs, icônes informatives, outline focus) : **≥ 3:1**
- Ne jamais transmettre une info par la couleur seule (ajouter icône, texte, motif)
- Voir [colors.md](colors.md) pour les cas limites (placeholder, liens, mode sombre, graphiques) et les outils de test

### 3. Tableaux (Thème 5)
```html
<!-- Tableau de données -->
<table>
  <caption>Récapitulatif des habilitations par statut</caption>
  <thead>
    <tr>
      <th scope="col">Nom</th>
      <th scope="col">Statut</th>
      <th scope="col">Date</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Habilitation A</th>
      <td>Validée</td>
      <td>2024-01-15</td>
    </tr>
  </tbody>
</table>
```

### 4. Liens (Thème 6)
Voir `examples.md` pour les cas complets. Règles clés :
- L'intitulé doit être **explicite hors contexte** (pas de "Cliquez ici")
- Lien externe → `target="_blank"` + `title="... - nouvelle fenêtre"` + `rel="noopener external"`
- Lien de téléchargement → indiquer format, poids, langue si différente
- Distinguer visuellement les liens du texte courant (ne pas supprimer le soulignement)

### 5. Scripts et composants dynamiques (Thème 7)
```html
<!-- Bouton toggle -->
<button type="button" aria-expanded="false" aria-controls="menu-id">
  Menu
</button>
<ul id="menu-id" hidden>...</ul>

<!-- Alerte dynamique -->
<!-- role="alert" implique déjà aria-live="assertive" — inutile de les combiner -->
<div role="alert">Message d'erreur critique</div>
<!-- role="status" implique déjà aria-live="polite" -->
<div role="status">Sauvegarde réussie</div>

<!-- Dialog / Modal -->
<dialog aria-labelledby="dialog-title" aria-describedby="dialog-desc">
  <h2 id="dialog-title">Confirmation</h2>
  <p id="dialog-desc">Voulez-vous supprimer cette habilitation ?</p>
</dialog>
```

### 6. Éléments obligatoires (Thème 8)
```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Titre de la page — DataPass</title>  <!-- Unique et pertinent -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
```

### 7. Structuration (Thème 9)
```html
<!-- Hiérarchie de titres (jamais sauter un niveau) -->
<h1>Titre principal (1 seul par page)</h1>
  <h2>Section principale</h2>
    <h3>Sous-section</h3>

<!-- Landmarks HTML5 -->
<!-- <header>/<footer> enfants directs de <body> ont déjà les rôles banner/contentinfo -->
<!-- Les rôles explicites ne sont utiles que pour la compat avec très vieux lecteurs d'écran -->
<header>En-tête du site</header>
<nav aria-label="Navigation principale">...</nav>
<main>Contenu principal</main>
<aside aria-label="Informations complémentaires">...</aside>
<footer>Pied de page</footer>

<!-- Listes sémantiques -->
<ul> <!-- liste non ordonnée -->
<ol> <!-- liste ordonnée -->
<dl><dt>Terme</dt><dd>Définition</dd></dl>
```

### 8. Présentation de l'information (Thème 10)
- **10.1** : ne pas utiliser CSS `content:` pour véhiculer une information textuelle
- **10.7** : le focus clavier est toujours visible — ne jamais écrire `outline: none` sans alternative
- **10.11** : pas de scroll horizontal à 320px de large (zoom 400% ou mobile portrait)

```css
/* ❌ Information portée uniquement par CSS */
.required::after { content: ' *'; }

/* ✅ Information dans le HTML */
<span aria-hidden="true"> *</span>
<span class="fr-sr-only">(obligatoire)</span>

/* ❌ Suppression du focus */
:focus { outline: none; }

/* ✅ Focus personnalisé visible */
:focus-visible { outline: 2px solid #0a76f6; outline-offset: 2px; }
```

Champs de langue étrangère (RGAA 8.7) :
```html
<!-- Passage en langue étrangère dans le contenu -->
<p>Ce service respecte le <span lang="en">GDPR compliance framework</span>.</p>
```

### 9. Formulaires (Thème 11)
```html
<!-- Label explicite -->
<label for="email">Adresse e-mail <span aria-hidden="true">*</span></label>
<input type="email" id="email" name="email" required
       aria-required="true"
       aria-describedby="email-hint email-error">
<p id="email-hint" class="fr-hint-text">Format : nom@domaine.fr</p>
<p id="email-error" role="alert" class="fr-error-text" hidden>
  Veuillez saisir une adresse e-mail valide.
</p>

<!-- Groupe de champs liés -->
<fieldset>
  <legend>Civilité</legend>
  <label><input type="radio" name="civility" value="m"> M.</label>
  <label><input type="radio" name="civility" value="mme"> Mme</label>
</fieldset>

<!-- Champ obligatoire — indiquer en début de formulaire -->
<p>Les champs marqués d'un <span aria-hidden="true">*</span>
   <span class="sr-only">astérisque</span> sont obligatoires.</p>
```

### 9. Navigation (Thème 12)
```html
<!-- Liens d'évitement (premier élément de la page) -->
<nav aria-label="Accès rapide">
  <a href="#main" class="fr-skip-links__link">Aller au contenu principal</a>
  <a href="#nav" class="fr-skip-links__link">Aller à la navigation</a>
</nav>

<!-- Navigation avec aria-current -->
<nav aria-label="Navigation principale">
  <ul>
    <li><a href="/accueil" aria-current="page">Accueil</a></li>
    <li><a href="/habilitations">Habilitations</a></li>
  </ul>
</nav>

<!-- Fil d'ariane -->
<nav aria-label="Fil d'Ariane">
  <ol>
    <li><a href="/">Accueil</a></li>
    <li><a href="/habilitations">Habilitations</a></li>
    <li aria-current="page">Détail habilitation</li>
  </ol>
</nav>
```

---

## Anti-patterns ARIA — À ne jamais faire

```html
<!-- ❌ tabindex > 0 : casse l'ordre naturel de navigation -->
<button tabindex="3">Soumettre</button>
<!-- ✅ Ne jamais utiliser tabindex > 0. Réorganiser le DOM si l'ordre pose problème. -->

<!-- ❌ <div> cliquable : pas de rôle, pas de clavier, pas de sémantique -->
<div onclick="submit()" class="btn">Envoyer</div>
<!-- ✅ -->
<button type="button" onclick="submit()">Envoyer</button>

<!-- ❌ aria-label sur un élément non-interactif sans rôle : ignoré par la plupart des lecteurs d'écran -->
<div aria-label="Section résultats">...</div>
<!-- ✅ Ajouter un rôle, ou utiliser un élément sémantique natif -->
<section aria-labelledby="results-title">
  <h2 id="results-title">Résultats</h2>
</section>

<!-- ❌ Double annonce : aria-label écrase le texte visible — lecteur d'écran lit aria-label seulement -->
<button aria-label="Supprimer l'habilitation">Supprimer</button>
<!-- Si aria-label et texte visible disent des choses différentes, c'est désorientant -->
<!-- ✅ Option 1 : aria-label seul si le texte visible est trop court -->
<button aria-label="Supprimer l'habilitation API Particulier — DINUM">Supprimer</button>
<!-- ✅ Option 2 : compléter le texte visible avec fr-sr-only -->
<button>Supprimer<span class="fr-sr-only"> l'habilitation API Particulier — DINUM</span></button>

<!-- ❌ role="presentation" sur un élément interactif : supprime sa sémantique -->
<button role="presentation">Valider</button>
<!-- Résultat : le bouton existe mais n'a plus de rôle "button" pour le lecteur d'écran -->
<!-- ✅ Ne jamais mettre role="presentation"/"none" sur button, a, input, select, etc. -->
```

## Patterns ARIA essentiels

| Pattern | Role | States/Properties clés |
|---------|------|------------------------|
| Bouton toggle | `button` | `aria-expanded`, `aria-controls` |
| Menu déroulant | `menu`, `menuitem` | `aria-haspopup`, `aria-expanded` |
| Onglets | `tablist`, `tab`, `tabpanel` | `aria-selected`, `aria-controls` |
| Accordéon | `button` | `aria-expanded`, `aria-controls` |
| Modal | `dialog` | `aria-modal`, `aria-labelledby` |
| Alerte | `alert` | `aria-live="assertive"` |
| Statut | `status` | `aria-live="polite"` |
| Barre de progression | `progressbar` | `aria-valuenow`, `aria-valuemin`, `aria-valuemax` |
| Tooltip | `tooltip` | `aria-describedby` |
| Champ de recherche | `search` (landmark) | `role="searchbox"` |

**Référence complète** : https://www.w3.org/WAI/ARIA/apg/

---

## Navigation clavier — Comportements attendus

| Touche | Comportement |
|--------|-------------|
| `Tab` | Passer au prochain élément focusable |
| `Shift+Tab` | Élément focusable précédent |
| `Enter` | Activer lien/bouton |
| `Espace` | Activer bouton/checkbox |
| `Flèches` | Naviguer dans composants (menu, tabs, select) |
| `Escape` | Fermer modal/menu |
| `Home`/`End` | Premier/dernier élément d'une liste |

**Piège à focus** : Les modales doivent piéger le focus (tab cycle dans la modale).

---

## Texte pour lecteurs d'écran uniquement

```css
/* Classe DSFR : fr-sr-only */
.fr-sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

```html
<!-- Exemple d'utilisation -->
<button>
  <svg aria-hidden="true">...</svg>
  <span class="fr-sr-only">Supprimer l'habilitation</span>
</button>
```

---

## Règles DSFR spécifiques à l'accessibilité

Ces règles complètent le HTML/ARIA — elles sont propres à l'implémentation DSFR.

### Icônes
```html
<!-- Icône décorative : toujours aria-hidden + focusable=false -->
<span class="fr-icon-arrow-right-line" aria-hidden="true"></span>

<!-- SVG décoratif -->
<svg aria-hidden="true" focusable="false">...</svg>

<!-- Icône seule comme bouton : label obligatoire -->
<button aria-label="Fermer">
  <span class="fr-icon-close-line" aria-hidden="true"></span>
</button>
```

### Alertes et notifications
- Le **type d'alerte doit être indiqué textuellement** dans le contenu : « information », « erreur », « succès », « attention » (pas uniquement par couleur/icône)
- Les **toast (alertes temporaires) sont à éviter** — elles disparaissent avant que les lecteurs d'écran aient pu les lire
- Alerte ajoutée dynamiquement : `role="alert"` pour erreurs/avertissements, `role="status"` pour succès/info
- À la fermeture d'une alerte avec bouton, **repositionner le focus** à un endroit pertinent

```html
<!-- Correct : type indiqué textuellement -->
<div class="fr-alert fr-alert--error" role="alert">
  <h3 class="fr-alert__title">Erreur — Formulaire incomplet</h3>
  <p>Veuillez remplir tous les champs obligatoires.</p>
</div>

<!-- Incorrect : type uniquement par couleur/icône -->
<div class="fr-alert fr-alert--error">
  <h3 class="fr-alert__title">Formulaire incomplet</h3>
</div>
```

### Accordéons
- Privilégier le mode **"Groupe dissocié"** (chaque accordéon s'ouvre indépendamment) plutôt que le comportement exclusif (un seul ouvert à la fois) — le comportement exclusif peut désorienter les utilisateurs de lecteurs d'écran
- Le titre `hx` doit être cohérent avec la hiérarchie de la page

### Liens
- **Lien externe** → `target="_blank"` + `title="libellé - nouvelle fenêtre"` + `rel="noopener external"` + classe `fr-link`
- **Lien dans un texte courant** → ne pas utiliser `fr-link` (le soulignement natif est suffisant et attendu)
- **Lien de téléchargement** → classe `fr-link--download` + détail format/poids dans `<span class="fr-link__detail">`
- **Lien ambigu** (ex: « Consulter » répété) → compléter avec `fr-sr-only`

### Badges et étiquettes de statut
```html
<!-- Le badge seul (couleur + texte court) peut manquer de contexte -->
<span class="fr-badge fr-badge--success">Validée</span>

<!-- Dans un tableau : ajouter contexte pour lecteurs d'écran si nécessaire -->
<td>
  <span class="fr-badge fr-badge--success" aria-label="Statut : Validée">Validée</span>
</td>
```

### Modale (fr-modal)
- Le composant DSFR gère le piège à focus automatiquement
- Le bouton de fermeture doit avoir un intitulé explicite : « Fermer » ou `aria-label="Fermer la fenêtre modale"`
- À la fermeture, le focus revient sur l'élément déclencheur

### Session et limites de temps (RGAA 13.1)
DataPass a des sessions authentifiées. Si la session expire pendant qu'un utilisateur remplit un long formulaire, il perd ses données. Le RGAA exige :
- Avertir l'utilisateur avant l'expiration (ex: modale de prolongation)
- Permettre de prolonger la session sans perdre les données
- Ou donner au moins 20 heures de session

```erb
<%# Avertissement d'expiration de session — accessible %>
<div id="session-warning" role="alertdialog" aria-modal="true"
     aria-labelledby="session-title" hidden>
  <h2 id="session-title">Votre session va expirer</h2>
  <p>Votre session expire dans <span id="countdown">5</span> minutes.</p>
  <button type="button" id="extend-session">Prolonger la session</button>
</div>
```

### Upload de fichiers (RGAA 11.1, 11.2)
```html
<!-- Label explicite sur le champ -->
<label for="justificatif">
  Pièce justificative
  <span class="fr-hint-text">PDF ou image, 10 Mo maximum</span>
</label>
<input type="file" id="justificatif" name="justificatif"
       accept=".pdf,.jpg,.png"
       aria-describedby="justificatif-hint">
<p id="justificatif-hint" class="fr-hint-text">
  Formats acceptés : PDF, JPG, PNG. Taille maximale : 10 Mo.
</p>

<!-- Fichier uploadé : annoncé + bouton de suppression contextualisé -->
<ul aria-live="polite" aria-label="Fichiers sélectionnés">
  <li>
    rapport.pdf (2,3 Mo)
    <button type="button"
            aria-label="Supprimer le fichier rapport.pdf">
      Supprimer
    </button>
  </li>
</ul>

<!-- Barre de progression d'upload -->
<div role="progressbar"
     aria-valuenow="65"
     aria-valuemin="0"
     aria-valuemax="100"
     aria-label="Envoi de rapport.pdf : 65%">
  <div style="width: 65%"></div>
</div>
```

### Navigation DSFR — accessibilite.md par composant
Le `dsfr-skill` contient des fichiers `accessibilite.md` détaillés par composant (interactions clavier, restitution lecteurs d'écran, critères RGAA) :
- `.claude/skills/dsfr-skill/skills/dsfr-skill/composants/<composant>/accessibilite.md`
- Composants documentés : accordion, alert, badge, button, checkbox, input, link, modal, radio, select, tabs, etc.

---

## Ressources

### Liens RGAA directs par thème
| Thème | Lien |
|-------|------|
| 1 — Images | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic1 |
| 3 — Couleurs | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic3 |
| 5 — Tableaux | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic5 |
| 6 — Liens | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic6 |
| 7 — Scripts | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic7 |
| 8 — Éléments obligatoires | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic8 |
| 9 — Structuration | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic9 |
| 11 — Formulaires | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic11 |
| 12 — Navigation | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic12 |
| 13 — Consultation | https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#topic13 |

### Fichiers de ce skill
- [Exemples de code DSFR](examples-dsfr.md) — pour DataPass et projets DSFR
- [Exemples de code HTML/WCAG/ARIA](examples-html.md) — référence universelle sans framework
- [Contrastes, couleurs et outils de test](colors.md)
- [Structure HTML — validation et outils](html-structure.md)
- [Checklists d'audit par type de page](checklist.md)
- [Patterns Rails / ViewComponent / Stimulus](rails-patterns.md)
- [Ressources, articles et outils](resources.md)
- [Impacts par type de handicap](impacts.md)