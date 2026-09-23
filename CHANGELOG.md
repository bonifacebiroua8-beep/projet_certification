# Changelog

Toutes les modifications notables de ce projet sont documentées dans ce fichier.
Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/).

## [1.2.0] - 2026-09-23

### Ajouté
- Internationalisation FR + EN (`flutter_localizations` + ARB)
- Écran **Profil** (avatar, accès paramètres, déconnexion)
- Écran **Paramètres** (choix langue FR/EN, à propos)
- Navigation 4 onglets (Ventes / Stocks / Dettes / Profil)
- Tests widgets (9) : Login, Register, Home, AddProduct, Profile
- Tests d'intégration (2) : navigation login↔register, bascule i18n
- CI/CD GitHub Actions : `flutter analyze` + `flutter test` automatiques
- Accessibilité : `Semantics` labels sur les écrans et boutons
- Gestion du `setState after dispose` avec vérification `mounted`

### Modifié
- `flutter_dotenv` rétrogradé en 5.2.1 pour compatibilité tests
- Repositories : injection `getUserId` pour testabilité
- Dialogs : `initialValue` au lieu de `value` déprécié
- Settings : `RadioGroup` au lieu de `RadioListTile` déprécié

## [1.1.0] - 2026-09-06

### Ajouté
- Gestion des 3 features : Ventes, Stocks, Dettes
- Formulaires d'ajout (dialog) pour chaque feature
- Mode hors-ligne (cache SQLite) avec stratégie cache-first
- Gestion d'erreurs différenciée (network / timeout / server)
- Session persistante (AuthGate vérifie le token au démarrage)
- Bouton logout dans la HomeScreen

### Corrigé
- Erreur `ConflictAlgorithm` non importé dans les datasources locales
- Fallback cache vide géré proprement

## [1.0.0] - 2026-09-05

### Ajouté
- Authentification JWT via Supabase (login / register / refresh)
- Client Dio avec intercepteur JWT + refresh token automatique sur 401
- Stockage sécurisé des tokens (flutter_secure_storage)
- Cache SQLite (sqflite) pour les 3 tables
- Architecture feature-first (core / features / l10n)
- Tests unitaires (11) sur les 3 repositories (Sales, Products, Debts)
