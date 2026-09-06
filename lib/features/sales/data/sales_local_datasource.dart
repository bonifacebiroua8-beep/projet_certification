import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../core/storage/local_db.dart';
import '../domain/sale_model.dart';

class SalesLocalDataSource {
  Future<List<SaleModel>> getAll(String userId) async {
    final db = await LocalDb.instance;
    final rows = await db.query('ventes', where: 'user_id = ?', whereArgs: [userId],
        orderBy: 'created_at DESC');
    return rows.map((e) => SaleModel.fromMap(e)).toList();
  }

  Future<void> saveAll(List<SaleModel> items) async {
    final db = await LocalDb.instance;
    final batch = db.batch();
    for (final s in items) {
      batch.insert('ventes', s.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}