import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/features/auth/presentation/register_screen.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnv();
  });

  testWidgets('RegisterScreen affiche le formulaire', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: RegisterScreen(),
      ),
    );
    await tester.pump();

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
  });

  testWidgets('RegisterScreen - champs sont éditables', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: RegisterScreen(),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'new@test.cm');
    expect(find.text('new@test.cm'), findsOneWidget);
  });
}
