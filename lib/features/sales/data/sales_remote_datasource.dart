import '../../../core/network/dio_client.dart';
import '../domain/sale_model.dart';

class SalesRemoteDataSource {
  Future<List<SaleModel>> fetchAll() async {
    final res = await DioClient.instance.get('/ventes?select=*&order=created_at.desc');
    return (res.data as List).map((e) => SaleModel.fromJson(e)).toList();
  }

  Future<void> create(SaleModel s) =>
      DioClient.instance.post('/ventes', data: s.toInsertJson());
}