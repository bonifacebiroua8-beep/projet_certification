import '../../../core/network/dio_client.dart';
import '../domain/product_model.dart';

class ProductsRemoteDataSource {
  Future<List<ProductModel>> fetchAll() async {
    final res = await DioClient.instance.get('/produits?select=*');
    return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> create(ProductModel p) =>
      DioClient.instance.post('/produits', data: p.toInsertJson());
}