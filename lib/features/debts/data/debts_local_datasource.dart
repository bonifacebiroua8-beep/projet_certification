import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../core/storage/local_db.dart';
import '../domain/debt_model.dart';

class DebtsLocalDataSource {
  Future<List<DebtModel>> getAll(String userId) async {
    final db = await LocalDb.instance;
    final rows = await db.query('dettes', where: 'user_id = ?', whereArgs: [userId]);
    return rows.map((e) => DebtModel.fromMap(e)).toList();
  }

  Future<void> saveAll(List<DebtModel> items) async {
    final db = await LocalDb.instance;
    final batch = db.batch();
    for (final d in items) {
      batch.insert('dettes', d.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}