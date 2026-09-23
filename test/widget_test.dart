import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations FR expose les traductions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: Scaffold(body: SizedBox()),
      ),
    );

    final ctx = tester.element(find.byType(Scaffold));
    final t = AppLocalizations.of(ctx)!;

    expect(t.login, 'Connexion');
    expect(t.sales, 'Ventes');
    expect(t.stock, 'Stocks');
    expect(t.debts, 'Dettes');
    expect(t.profile, 'Profil');
  });

  testWidgets('AppLocalizations EN expose les traductions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: SizedBox()),
      ),
    );

    final ctx = tester.element(find.byType(Scaffold));
    final t = AppLocalizations.of(ctx)!;

    expect(t.login, 'Login');
    expect(t.sales, 'Sales');
    expect(t.stock, 'Stock');
    expect(t.debts, 'Debts');
    expect(t.profile, 'Profile');
  });
}