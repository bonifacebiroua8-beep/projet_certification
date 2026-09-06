import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/error/app_exception.dart';
import '../domain/sale_model.dart';
import 'sales_remote_datasource.dart';
import 'sales_local_datasource.dart';

class SalesRepository {
  final SalesRemoteDataSource remote;
  final SalesLocalDataSource local;

  SalesRepository({SalesRemoteDataSource? remote, SalesLocalDataSource? local})
      : remote = remote ?? SalesRemoteDataSource(),
        local = local ?? SalesLocalDataSource();

  Future<List<SaleModel>> getSales() async {
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

  Future<void> addSale(String produitId, double quantite, double prixUnitaire, String client) async {
    final userId = await SecureStorage.getUserId() ?? '';
    final s = SaleModel(id: '', userId: userId, produitId: produitId, quantite: quantite,
        prixUnitaire: prixUnitaire, montantTotal: quantite * prixUnitaire, client: client,
        modePaiement: 'comptant', createdAt: '');
    try {
      await remote.create(s);
    } catch (e) {
      throw mapDioException(e);
    }
  }
}