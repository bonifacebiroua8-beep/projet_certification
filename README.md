## 📁 `README.md`

```markdown
# UbuntuTech — App mobile (certification)

Application Flutter connectée à un backend réel (Supabase), architecture feature-first.

## Fonctionnalités
- Authentification JWT (login/register/logout) via Supabase Auth
- Session persistante (AuthGate vérifie le token au démarrage)
- 3 écrans connectés à une API REST (Supabase PostgREST) : Ventes, Stocks, Dettes
- Formulaires de création sur les 3 écrans
- Cache local SQLite (sqflite), stratégie cache-first
- Mode hors-ligne : affichage des données en cache si pas de réseau
- Gestion d'erreurs différenciée (réseau / timeout / serveur)

## Architecture

```
lib/core     → config, network (Dio + intercepteur JWT + refresh token), storage, error
lib/features → auth, sales, products, debts, home (data/domain/presentation par feature)
```

## Configuration

1. Créer un projet Supabase, exécuter le schéma SQL ci-dessous
2. Créer un fichier `.env` à la racine :
```

SUPABASE_URL=https://<projet>.supabase.co
SUPABASE_ANON_KEY=<clé anon>
```
3. `flutter pub get`
4. `flutter run`

## Schéma SQL (Supabase)

```sql
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

create table depenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  libelle text not null,
  montant numeric not null,
  categorie text,
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
alter table depenses enable row level security;
alter table dettes enable row level security;

create policy "own_data_produits" on produits for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_ventes" on ventes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_depenses" on depenses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own_data_dettes" on dettes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## Tests

`flutter test` — 9 tests unitaires sur la couche repository (Sales, Products, Debts) : cas succès, repli sur cache, gestion d'erreur.
```

