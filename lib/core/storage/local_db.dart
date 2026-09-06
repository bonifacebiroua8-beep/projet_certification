import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDb {
  static Database? _db;

  static Future<Database> get instance async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'ubuntutech.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE produits (
            id TEXT PRIMARY KEY, user_id TEXT, nom TEXT,
            quantite REAL, prix_unitaire REAL, seuil_alerte REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE ventes (
            id TEXT PRIMARY KEY, user_id TEXT, produit_id TEXT,
            quantite REAL, prix_unitaire REAL, montant_total REAL,
            client TEXT, mode_paiement TEXT, created_at TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE dettes (
            id TEXT PRIMARY KEY, user_id TEXT, client TEXT,
            montant REAL, montant_rembourse REAL, created_at TEXT
          )
        ''');
      },
    );
  }
}