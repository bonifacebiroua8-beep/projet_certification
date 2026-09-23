import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/features/auth/presentation/login_screen.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnv();
  });

  testWidgets('LoginScreen affiche email, password et bouton', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: LoginScreen(),
      ),
    );
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });

  testWidgets('LoginScreen - champs sont éditables', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: LoginScreen(),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'test@test.cm');
    await tester.enterText(find.byType(TextField).last, 'Test1234!');

    expect(find.text('test@test.cm'), findsOneWidget);
  });
}
