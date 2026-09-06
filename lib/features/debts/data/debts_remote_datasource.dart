import '../../../core/network/dio_client.dart';
import '../domain/debt_model.dart';

class DebtsRemoteDataSource {
  Future<List<DebtModel>> fetchAll() async {
    final res = await DioClient.instance.get('/dettes?select=*');
    return (res.data as List).map((e) => DebtModel.fromJson(e)).toList();
  }

  Future<void> create(DebtModel d) =>
      DioClient.instance.post('/dettes', data: d.toInsertJson());
}