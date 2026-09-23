# Changelog

Toutes les modifications notables de ce projet sont documentées ici.

## [1.2.0] - 2026-09-23

### Ajouté
- Internationalisation FR + EN (flutter_localizations + ARB)
- Écran Profil (avatar, paramètres, déconnexion)
- Écran Paramètres (langue FR/EN, à propos)
- Navigation 4 onglets (Ventes / Stocks / Dettes / Profil)
- 9 tests widgets (Login, Register, Home, AddProduct, Profile)
- 2 tests d'intégration (navigation login↔register, bascule i18n)
- CI/CD GitHub Actions (flutter analyze + flutter test)
- Accessibilité : labels Semantics sur éléments interactifs

### Modifié
- flutter_dotenv rétrogradé en 5.2.1 (compatibilité tests)
- Repositories : injection getUserId pour testabilité
- Dialogs : initialValue au lieu de value déprécié
- Settings : RadioGroup au lieu de RadioListTile déprécié

### Corrigé
- Bug setState() called after dispose() avec vérification mounted

## [1.1.0] - 2026-09-06

### Ajouté
- Modules Ventes, Stocks, Dettes
- Formulaires d'ajout (dialog) pour chaque module
- Cache SQLite (stratégie cache-first)
- Mode hors-ligne avec fallback
- Gestion erreurs différenciée (network / timeout / server)
- Session persistante (AuthGate)
- Bouton logout dans HomeScreen

### Corrigé
- ConflictAlgorithm import dans les datasources locales
- Fallback cache vide géré proprement

## [1.0.0] - 2026-09-05

### Ajouté
- Authentification JWT via Supabase (login / register / refresh)
- Client Dio avec intercepteur JWT + refresh token sur 401
- Stockage sécurisé des tokens (flutter_secure_storage)
- Cache SQLite (sqflite) pour les 3 tables
- Architecture feature-first (core / features)
- 11 tests unitaires sur les 3 repositories
