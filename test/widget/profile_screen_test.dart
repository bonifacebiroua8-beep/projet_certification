import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ubuntutech_frontend/features/profile/presentation/profile_screen.dart';
import 'package:ubuntutech_frontend/l10n/app_localizations.dart';
import 'test_setup.dart';

void main() {
  setUpAll(() async {
    await setupTestEnv();
  });

  testWidgets('ProfileScreen affiche avatar, parametres, logout', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('fr'),
        home: ProfileScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Déconnexion'), findsOneWidget);
  });
}
