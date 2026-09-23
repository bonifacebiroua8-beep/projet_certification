import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await setupIntegrationEnv();
  });

  testWidgets(
    'i18n : bascule FR → EN sur le même écran',
    (tester) async {
      // Écran FR
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('fr'),
          home: Scaffold(
            body: Builder(
              builder: _buildContent,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Connexion'), findsOneWidget);
      expect(find.text('Ventes'), findsOneWidget);

      // Écran EN
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: _buildContent,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Sales'), findsOneWidget);
    },
  );
}

Widget _buildContent(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  return Column(
    children: [
      Text(t.login),
      Text(t.sales),
    ],
  );
}
