import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/features/home/home_screen.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnv();
  });

  testWidgets('HomeScreen affiche 4 onglets', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: HomeScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Ventes'), findsWidgets);
    expect(find.text('Stocks'), findsWidgets);
    expect(find.text('Dettes'), findsWidgets);
    expect(find.text('Profil'), findsWidgets);
  });

  testWidgets('HomeScreen - tap sur Stocks change l onglet', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: HomeScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.inventory_2));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
