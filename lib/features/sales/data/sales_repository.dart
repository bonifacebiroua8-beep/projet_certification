import '../../../core/error/app_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../domain/sale_model.dart';
import 'sales_remote_datasource.dart';
import 'sales_local_datasource.dart';

class SalesRepository {
  final SalesRemoteDataSource remote;
  final SalesLocalDataSource local;
  final Future<String?> Function() _getUserId;

  SalesRepository({
    SalesRemoteDataSource? remote,
    SalesLocalDataSource? local,
    Future<String?> Function()? getUserId,
  })  : remote = remote ?? SalesRemoteDataSource(),
        local = local ?? SalesLocalDataSource(),
        _getUserId = getUserId ?? SecureStorage.getUserId;

  Future<List<SaleModel>> getSales() async {
    final userId = await _getUserId() ?? '';
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
    final userId = await _getUserId() ?? '';
    final s = SaleModel(
      id: '',
      userId: userId,
      produitId: produitId,
      quantite: quantite,
      prixUnitaire: prixUnitaire,
      montantTotal: quantite * prixUnitaire,
      client: client,
      modePaiement: 'comptant',
      createdAt: '',
    );
    try {
      await remote.create(s);
    } catch (e) {
      throw mapDioException(e);
    }
  }
}