import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuntutech_frontend/features/products/data/products_repository.dart';
import 'package:ubuntutech_frontend/features/products/data/products_remote_datasource.dart';
import 'package:ubuntutech_frontend/features/products/data/products_local_datasource.dart';
import 'package:ubuntutech_frontend/features/products/domain/product_model.dart';

class MockRemote extends Mock implements ProductsRemoteDataSource {}
class MockLocal extends Mock implements ProductsLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late ProductsRepository repo;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repo = ProductsRepository(remote: remote, local: local);
    when(() => local.saveAll(any())).thenAnswer((_) async {});
  });

  test('retourne les produits distants et les met en cache', () async {
    final fake = [ProductModel(id: '1', userId: 'u', nom: 'Riz', quantite: 10,
        prixUnitaire: 500, seuilAlerte: 5)];
    when(() => remote.fetchAll()).thenAnswer((_) async => fake);

    final result = await repo.getProducts();

    expect(result.length, 1);
    verify(() => local.saveAll(fake)).called(1);
  });

  test('repli sur le cache si erreur réseau et cache non vide', () async {
    final cached = [ProductModel(id: '1', userId: 'u', nom: 'Riz', quantite: 10,
        prixUnitaire: 500, seuilAlerte: 5)];
    when(() => remote.fetchAll()).thenThrow(Exception('network error'));
    when(() => local.getAll(any())).thenAnswer((_) async => cached);

    final result = await repo.getProducts();

    expect(result.length, 1);
  });

  test('addProduct propage une AppException si l\'API échoue', () async {
    when(() => remote.create(any())).thenThrow(Exception('fail'));

    expect(() => repo.addProduct('Riz', 10, 500, 5), throwsA(isA<Exception>()));
  });
}