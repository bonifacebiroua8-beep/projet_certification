import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../core/storage/local_db.dart';
import '../domain/product_model.dart';

class ProductsLocalDataSource {
  Future<List<ProductModel>> getAll(String userId) async {
    final db = await LocalDb.instance;
    final rows = await db.query('produits', where: 'user_id = ?', whereArgs: [userId]);
    return rows.map((e) => ProductModel.fromMap(e)).toList();
  }

  Future<void> saveAll(List<ProductModel> items) async {
    final db = await LocalDb.instance;
    final batch = db.batch();
    for (final p in items) {
      batch.insert('produits', p.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}