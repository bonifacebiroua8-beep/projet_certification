import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/error/app_exception.dart';
import '../domain/product_model.dart';
import 'products_remote_datasource.dart';
import 'products_local_datasource.dart';

class ProductsRepository {
  final ProductsRemoteDataSource remote;
  final ProductsLocalDataSource local;

  ProductsRepository({ProductsRemoteDataSource? remote, ProductsLocalDataSource? local})
      : remote = remote ?? ProductsRemoteDataSource(),
        local = local ?? ProductsLocalDataSource();

  Future<List<ProductModel>> getProducts() async {
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

  Future<void> addProduct(String nom, double quantite, double prixUnitaire, double seuil) async {
    final userId = await SecureStorage.getUserId() ?? '';
    final p = ProductModel(id: '', userId: userId, nom: nom, quantite: quantite,
        prixUnitaire: prixUnitaire, seuilAlerte: seuil);
    try {
      await remote.create(p);
    } catch (e) {
      throw mapDioException(e);
    }
  }
}