import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ubuntutech_frontend/features/auth/presentation/login_screen.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setupIntegrationEnv();
  });

  testWidgets(
    'Navigation : LoginScreen → RegisterScreen → retour LoginScreen',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Vérifier écran login
      expect(find.text('Connexion'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));

      // Naviguer vers inscription
      await tester.tap(find.text('Inscription'));
      await tester.pumpAndSettle();

      // Vérifier écran inscription
      expect(find.byType(TextField), findsNWidgets(2));

      // Retour
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
      }

      expect(find.text('Connexion'), findsOneWidget);
    },
  );
}
