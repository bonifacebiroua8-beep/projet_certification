import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/features/products/presentation/add_product_dialog.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnv();
  });

  testWidgets('AddProductDialog affiche 4 champs + actions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: Scaffold(body: AddProductDialog()),
      ),
    );
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.text('Nouveau produit'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
  });

  testWidgets('AddProductDialog - champ Nom éditable', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: Scaffold(body: AddProductDialog()),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'Riz');
    expect(find.text('Riz'), findsOneWidget);
  });
}
