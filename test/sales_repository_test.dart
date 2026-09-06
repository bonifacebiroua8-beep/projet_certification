import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuntutech_frontend/features/sales/data/sales_repository.dart';
import 'package:ubuntutech_frontend/features/sales/data/sales_remote_datasource.dart';
import 'package:ubuntutech_frontend/features/sales/data/sales_local_datasource.dart';
import 'package:ubuntutech_frontend/features/sales/domain/sale_model.dart';

class MockRemote extends Mock implements SalesRemoteDataSource {}
class MockLocal extends Mock implements SalesLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late SalesRepository repo;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repo = SalesRepository(remote: remote, local: local);
    when(() => local.saveAll(any())).thenAnswer((_) async {});
  });

  test('retourne les données distantes et les met en cache', () async {
    final fake = [
      SaleModel(
        id: '1',
        userId: 'u',
        produitId: 'p',
        quantite: 1,
        prixUnitaire: 100,
        montantTotal: 100,
        client: '',
        modePaiement: 'comptant',
        createdAt: '',
      )
    ];
    when(() => remote.fetchAll()).thenAnswer((_) async => fake);

    final result = await repo.getSales();

    expect(result.length, 1);
    verify(() => local.saveAll(fake)).called(1);
  });

  test('repli sur le cache local si erreur réseau', () async {
    when(() => remote.fetchAll()).thenThrow(Exception('network error'));
    when(() => local.getAll(any())).thenAnswer((_) async => []);

    final result = await repo.getSales();

    expect(result, isEmpty);
  });

  test('addSale retourne false si l\'API échoue', () async {
    when(() => remote.create(any())).thenThrow(Exception('fail'));

    final ok = await repo.addSale('p1', 2, 500, 'Paul');

    expect(ok, false);
  });
}