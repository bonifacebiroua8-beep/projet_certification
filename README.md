# UbuntuTech — Flutter Mobile App (Certification #2)

[![Flutter CI](https://github.com/bonifacebiroua8-beep/projet_certification/actions/workflows/flutter.yml/badge.svg)](https://github.com/bonifacebiroua8-beep/projet_certification/actions/workflows/flutter.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.35+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)
![Tests](https://img.shields.io/badge/tests-22%20passing-brightgreen)
![Coverage](https://img.shields.io/badge/coverage-3%20levels-blue)
![Platform](https://img.shields.io/badge/platform-Android-3DDC84?logo=android)
![License](https://img.shields.io/badge/license-Educational-lightgrey)

> Production-ready Flutter application connected to a real backend (Supabase),
> with offline-first architecture, full internationalization, accessibility
> support, and automated CI/CD.

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Architecture](#-architecture)
- [Testing Strategy](#-testing-strategy)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Performance & Accessibility](#-performance--accessibility)
- [Configuration](#-configuration)
- [Database Schema](#-database-schema)
- [Stack](#-stack)
- [Requirements Coverage](#-requirements-coverage)
- [Author](#-author)

---

## 🎯 Overview

**UbuntuTech** is a production-ready Flutter mobile application built as part of
the NextFlutter certification program. It connects to a real Supabase backend
(PostgreSQL + Auth + PostgREST) and follows **Clean Architecture** with a
**feature-first** folder structure.

The app targets micro-entrepreneurs in Northern Cameroon and serves as the
foundation of the **Welva** product (V1 scope: French + English only).

---

## ✨ Features

### 1. Authentication (JWT)
- Email + password signup / login via Supabase Auth
- JWT tokens stored in `flutter_secure_storage`
- Silent refresh on 401 via Dio interceptor
- Session persistence (`AuthGate` checks token at startup)
- Logout clears tokens and returns to login

### 2. Three CRUD Modules
| Module | Read | Create | Offline Cache |
|--------|------|--------|---------------|
| **Ventes** (Sales) | ✅ List + pull-to-refresh | ✅ Modal dialog | ✅ SQLite |
| **Stocks** (Products) | ✅ List + low-stock alert | ✅ Modal dialog | ✅ SQLite |
| **Dettes** (Debts) | ✅ List + remaining amount | ✅ Modal dialog | ✅ SQLite |

### 3. Offline-First Architecture
- **Strategy:** cache-first (try remote → fallback to SQLite)
- Empty cache → typed `AppException` (no silent failure)
- Verified manually on physical device (network toggle)

### 4. Error Handling
Differentiated user-facing messages:
- `network` → "Pas de connexion réseau."
- `timeout` → "Délai dépassé. Vérifie ta connexion."
- `server`  → "Erreur serveur (500)."
- `unknown` → "Erreur inattendue."

### 5. Internationalization (FR + EN)
- `flutter_localizations` + `intl` + ARB files
- French as default locale, English switchable
- All UI strings extracted to `lib/l10n/`

### 6. Accessibility
- `Semantics` labels on all interactive elements
- Screen-reader friendly loading indicators
- Header semantics on AppBar titles

### 7. Navigation
- 4-tab `BottomNavigationBar` (Sales / Stock / Debts / Profile)
- Settings accessible from Profile
- Full logout flow

---

## 📸 Screenshots

> Captures prises sur TECNO BG6m (Android 14) lors des tests d'intégration.

| Login | Home (Sales) | Add Product | Profile |
|-------|--------------|-------------|---------|
| ![Login](docs/screenshots/login.png) | ![Home](docs/screenshots/home.png) | ![Add](docs/screenshots/add_product.png) | ![Profile](docs/screenshots/profile.png) |

*(Ajouter les images dans `docs/screenshots/` pour les afficher.)*

---

## 🏗️ Architecture

**Pattern:** Clean Architecture + Feature-first + Repository Pattern
lib/
├── core/ # Cross-cutting infrastructure
│ ├── config/
│ │ └── app_config.dart # Reads .env (SUPABASE_URL, ANON_KEY)
│ ├── error/
│ │ └── app_exception.dart # Typed errors + mapDioException()
│ ├── network/
│ │ ├── dio_client.dart # Singleton Dio + JWT interceptor
│ │ └── connectivity_service.dart
│ ├── storage/
│ │ ├── secure_storage.dart # Tokens, user_id, locale
│ │ └── local_db.dart # sqflite: 3 tables + migrations
│ └── utils/
│ └── jwt_utils.dart # Decode sub claim from JWT
│
├── features/ # One folder per business feature
│ ├── auth/
│ │ ├── data/ # remote datasource + repository
│ │ ├── domain/ # UserModel
│ │ └── presentation/ # login, register, auth_gate
│ ├── sales/
│ │ ├── data/ # sales_repository + remote/local DS
│ │ ├── domain/ # SaleModel
│ │ └── presentation/ # sales_screen + add_sale_dialog
│ ├── products/ # same pattern
│ ├── debts/ # same pattern
│ ├── profile/ # user info + logout
│ ├── settings/ # FR/EN switch + about
│ └── home/ # 4-tab navigation
│
└── l10n/ # ARB (FR + EN) + generated classes

**Key design decisions:**
- **Repository pattern** with local + remote data sources
- **Dependency injection** via optional constructor params
  (e.g. `getUserId` injectable for testability)
- **No platform channel usage** in unit tests

---

## 🧪 Testing Strategy

**22 tests passing** across 3 levels (pyramid approach):

| Level | Count | Location | Tools |
|-------|-------|----------|-------|
| **Unit** | 11 | `test/*_repository_test.dart` | `flutter_test` + `mocktail` |
| **Widget** | 9 | `test/widget/*_test.dart` | `flutter_test` |
| **Integration** | 2 | `integration_test/*.dart` | `integration_test` |
| **Total** | **22** | | |

### Unit tests coverage
- `SalesRepository` → success, cache fallback, error propagation
- `ProductsRepository` → success, cache fallback, error propagation
- `DebtsRepository` → success, cache fallback, error propagation

### Widget tests coverage
- `LoginScreen` → fields + button render, editable
- `RegisterScreen` → form renders, editable
- `HomeScreen` → 4 tabs, tab switching works
- `AddProductDialog` → 4 fields + actions, editable
- `ProfileScreen` → avatar + settings + logout render

### Integration tests coverage
- `app_navigation_test` → Login → Register → back to Login
- `i18n_switch_test` → FR → EN live translation switch

### Run tests locally
```bash
flutter test                          # 20 tests (unit + widget)
flutter test integration_test/        # 2 tests (integration)

🔄 CI/CD Pipeline
GitHub Actions — .github/workflows/flutter.yml

yaml
on:
  push:      { branches: [main] }
  pull_request: { branches: [main] }

jobs:
  analyze-and-test:
    runs-on: ubuntu-latest
    steps:
      - Checkout code
      - Setup Java 17
      - Setup Flutter (stable channel, cache enabled)
      - Create test .env
      - flutter pub get
      - flutter gen-l10n
      - flutter analyze          # 0 warning tolerated
      - flutter test             # all tests must pass
Status: ✅ Green on latest 3 commits.
https://github.com/bonifacebiroua8-beep/projet_certification/actions/workflows/flutter.yml/badge.svg

⚡ Performance & Accessibility
Performance
const constructors everywhere possible (e.g. _screens, icons)

Lazy loading: ListView.builder (not ListView)

mounted guards before every setState after await
(prevents "setState after dispose" errors)

Singleton Dio (no re-instantiation per request)

No unnecessary rebuilds: minimal setState scope

Accessibility
Semantics(label: ...) on all FABs, bottom-nav items, buttons

Semantics(textField: true) on all input fields

Semantics(header: true) on AppBar titles

CircularProgressIndicator(semanticsLabel: ...) on loading states

Screen-reader friendly list items (label describes content)

⚙️ Configuration
Prerequisites
Flutter SDK ≥ 3.35

Dart ≥ 3.11

Supabase account (free tier)

Setup steps
1. Create a Supabase project and run the SQL schema below.

2. Create .env at project root:

env
SUPABASE_URL=https://<your-project>.supabase.co
SUPABASE_ANON_KEY=<your-anon-key>
3. Install dependencies:

bash
flutter pub get
flutter gen-l10n
4. Run the app:

bash
flutter run
5. Run tests:

bash
flutter test
flutter test integration_test/
🗄️ Database Schema
sql
-- Products
create table produits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  nom text not null,
  quantite numeric not null default 0,
  prix_unitaire numeric not null default 0,
  seuil_alerte numeric default 5
);

-- Sales
create table ventes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  produit_id uuid references produits,
  quantite numeric not null,
  prix_unitaire numeric not null,
  montant_total numeric generated always as (quantite * prix_unitaire) stored,
  client text,
  mode_paiement text default 'comptant',
  created_at timestamptz default now()
);

-- Debts
create table dettes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  client text not null,
  montant numeric not null,
  montant_rembourse numeric default 0,
  created_at timestamptz default now()
);

-- Row Level Security (RLS) — one policy per table
alter table produits enable row level security;
alter table ventes enable row level security;
alter table dettes enable row level security;

create policy "own_data_produits" on produits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_ventes" on ventes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_dettes" on dettes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
🧰 Stack
Layer	Technology
Framework	Flutter 3.35+
Language	Dart 3.11+
Backend	Supabase (PostgreSQL + Auth GoTrue + PostgREST)
HTTP Client	Dio 5.x + custom interceptors
State Management	Riverpod 2.x
Local Storage	sqflite + flutter_secure_storage
Environment	flutter_dotenv 5.2.1
i18n	flutter_localizations + intl + ARB
Testing	flutter_test + mocktail + integration_test
CI/CD	GitHub Actions
Connectivity	connectivity_plus
✅ Requirements Coverage
Mapping to certification #2 requirements:

#	Requirement	Status	Evidence
1	Functional app with ≥ 5 screens	✅	Login, Register, Home (4 tabs), Profile, Settings
2	≥ 10 unit tests	✅	11 unit tests in test/*_repository_test.dart
3	≥ 5 widget tests	✅	9 widget tests in test/widget/*_test.dart
4	≥ 2 integration tests	✅	2 tests in integration_test/*.dart
5	No visible jank (60fps)	✅	const + lazy lists + minimal rebuilds
6	Optimized images / lazy loading	✅	ListView.builder everywhere
7	No unnecessary rebuilds	✅	const widgets + scoped setState
8	Accessibility (Semantics)	✅	Semantics labels on all interactive elements
9	i18n FR + EN minimum	✅	flutter_localizations + ARB files
10	CI/CD with lint + tests	✅	.github/workflows/flutter.yml (green)
11	Static analysis clean	✅	flutter analyze → No issues found!
12	Professional README	✅	This file
13	CHANGELOG (≥ 3 versions)	✅	CHANGELOG.md: 1.0.0 → 1.1.0 → 1.2.0
14	Public GitHub repo + green CI	✅	Link
15	APK / IPA demo	✅	Debug APK built & installed on TECNO BG6m
🗺️ Roadmap (post-certification)
□ Voice assistant (Whisper integration)
□ Fulfulde + Hausa localization (V2)
□ PDF export for credit reports
□ Mobile Money integration
□ iOS build
👤 Author
Biroua Wandeya Boniface (alias Combra)

Master's student in Applied AI — University of Ngaoundéré, Cameroon

GitHub: @bonifacebiroua8-beep

Project: UbuntuTech → product Welva — "Parle. Gère. Grandis."

📄 License
Educational project — UbuntuTech © 2026. All rights reserved.
