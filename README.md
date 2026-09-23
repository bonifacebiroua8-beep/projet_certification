powershell
@'
# UbuntuTech — App mobile (certification)

[![Flutter CI](https://github.com/bonifacebiroua8-beep/projet_certification/actions/workflows/flutter.yml/badge.svg)](https://github.com/bonifacebiroua8-beep/projet_certification/actions/workflows/flutter.yml)
![Flutter](https://img.shields.io/badge/Flutter-3.35+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)
![Tests](https://img.shields.io/badge/tests-22%20passing-success)
![Platform](https://img.shields.io/badge/platform-Android-3DDC84?logo=android)

Application Flutter connectée à un backend réel (Supabase), architecture feature-first.

## Fonctionnalités

- Authentification JWT (login / register / logout) via Supabase Auth
- Session persistante (AuthGate vérifie le token au démarrage)
- 5 écrans distincts : Login, Register, Home (4 onglets), Profil, Paramètres
- 3 modules connectés à l API REST Supabase (PostgREST) : Ventes, Stocks, Dettes
- Formulaires de création sur les 3 modules
- Cache local SQLite (sqflite), stratégie cache-first
- Mode hors-ligne : affichage des données en cache sans réseau
- Gestion d erreurs différenciée (réseau / timeout / serveur)
- Internationalisation FR + EN
- Accessibilité : labels Semantics sur les éléments interactifs

## Architecture
lib/
├── core/ # Infrastructure transverse
│ ├── config/ # AppConfig (.env)
│ ├── error/ # AppException, mapDioException
│ ├── network/ # DioClient + intercepteurs, Connectivity
│ ├── storage/ # SecureStorage, LocalDb (SQLite)
│ └── utils/ # JwtUtils
├── features/ # Modules métier (feature-first)
│ ├── auth/
│ ├── sales/
│ ├── products/
│ ├── debts/
│ ├── profile/
│ ├── settings/
│ └── home/
└── l10n/ # Fichiers ARB (FR + EN)

text

**Pattern :** Repository (data source local + remote) + injection de dépendances pour la testabilité.

## Configuration

### Prérequis
- Flutter ≥ 3.35
- Compte Supabase (free tier)

### Étapes

1. Créer un projet Supabase et exécuter le schéma SQL ci-dessous.
2. Créer un fichier `.env` à la racine :
SUPABASE_URL=https://<projet>.supabase.co
SUPABASE_ANON_KEY=<clé anon public>

text
3. Installer les dépendances :
```bash
flutter pub get
flutter gen-l10n
Lancer :

bash
flutter run
Schéma SQL (Supabase)
sql
create table produits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  nom text not null,
  quantite numeric not null default 0,
  prix_unitaire numeric not null default 0,
  seuil_alerte numeric default 5
);

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

create table dettes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  client text not null,
  montant numeric not null,
  montant_rembourse numeric default 0,
  created_at timestamptz default now()
);

alter table produits enable row level security;
alter table ventes enable row level security;
alter table dettes enable row level security;

create policy "own_data_produits" on produits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_ventes" on ventes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_dettes" on dettes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
Tests
bash
flutter test                       # 20 tests (11 unit + 9 widget)
flutter test integration_test/     # 2 tests d'intégration
Type	Nombre	Fichier
Unitaires	11	test/*_repository_test.dart
Widgets	9	test/widget/*_test.dart
Intégration	2	integration_test/*.dart
Total	22	
CI/CD
Workflow GitHub Actions (.github/workflows/flutter.yml) :

flutter analyze (0 warning exigé)

flutter test (tous les tests)

Déclenché sur push et PR vers main

Stack technique
Domaine	Techno
Framework	Flutter 3.35+
Langage	Dart 3.11+
Backend	Supabase (Postgres + Auth + PostgREST)
Client HTTP	Dio + intercepteurs JWT
État	Riverpod
Stockage local	sqflite + flutter_secure_storage
i18n	flutter_localizations + ARB
Tests	flutter_test + mocktail + integration_test
CI	GitHub Actions
Licence
Projet de certification — UbuntuTech 2026.
'@ | Out-File -Encoding utf8 README.md

text

---

### 4️⃣ **Push les 3 fichiers**

```powershell
git add .
git commit -m "ci: fix Flutter version + docs: README pro + CHANGELOG 3 versions"
git push
🚀 Ensuite :