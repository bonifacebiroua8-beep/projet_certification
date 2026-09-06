import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/error/app_exception.dart';
import '../domain/debt_model.dart';
import 'debts_remote_datasource.dart';
import 'debts_local_datasource.dart';

class DebtsRepository {
  final DebtsRemoteDataSource remote;
  final DebtsLocalDataSource local;

  DebtsRepository({DebtsRemoteDataSource? remote, DebtsLocalDataSource? local})
      : remote = remote ?? DebtsRemoteDataSource(),
        local = local ?? DebtsLocalDataSource();

  Future<List<DebtModel>> getDebts() async {
    final userId = await SecureStorage.getUserId() ?? '';
    try {
      final items = await remote.fetchAll();
      await local.saveAll(items);
      return items;
    } catch (e) {
      final cached = await local.getAll(userId);
      if (cached.isEmpty) throw mapDioException(e);
      return cached;
    }
  }

  Future<void> addDebt(String client, double montant) async {
    final userId = await SecureStorage.getUserId() ?? '';
    final d = DebtModel(id: '', userId: userId, client: client, montant: montant,
        montantRembourse: 0, createdAt: '');
    try {
      await remote.create(d);
    } catch (e) {
      throw mapDioException(e);
    }
  }
}