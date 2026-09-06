import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ubuntutech_frontend/features/debts/data/debts_repository.dart';
import 'package:ubuntutech_frontend/features/debts/data/debts_remote_datasource.dart';
import 'package:ubuntutech_frontend/features/debts/data/debts_local_datasource.dart';
import 'package:ubuntutech_frontend/features/debts/domain/debt_model.dart';

class MockRemote extends Mock implements DebtsRemoteDataSource {}
class MockLocal extends Mock implements DebtsLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockLocal local;
  late DebtsRepository repo;

  setUp(() {
    remote = MockRemote();
    local = MockLocal();
    repo = DebtsRepository(remote: remote, local: local);
    when(() => local.saveAll(any())).thenAnswer((_) async {});
  });

  test('retourne les dettes distantes et les met en cache', () async {
    final fake = [DebtModel(id: '1', userId: 'u', client: 'Paul', montant: 5000,
        montantRembourse: 0, createdAt: '')];
    when(() => remote.fetchAll()).thenAnswer((_) async => fake);

    final result = await repo.getDebts();

    expect(result.length, 1);
    verify(() => local.saveAll(fake)).called(1);
  });

  test('repli sur le cache vide si aucune donnée locale et erreur réseau', () async {
    when(() => remote.fetchAll()).thenThrow(Exception('network error'));
    when(() => local.getAll(any())).thenAnswer((_) async => []);

    expect(() => repo.getDebts(), throwsA(isA<Exception>()));
  });

  test('addDebt réussit si l\'API répond', () async {
    when(() => remote.create(any())).thenAnswer((_) async {});

    await repo.addDebt('Amina', 3000);

    verify(() => remote.create(any())).called(1);
  });
}