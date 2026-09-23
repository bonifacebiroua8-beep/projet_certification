import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/storage/secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLocale = 'fr';

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final loc = await SecureStorage.getLocale();
    if (!mounted) return;
    if (loc != null) setState(() => _currentLocale = loc);
  }

  Future<void> _changeLocale(String locale) async {
    await SecureStorage.saveLocale(locale);
    if (!mounted) return;
    setState(() => _currentLocale = locale);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Langue changée : $locale (redémarre l\'app)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(t.language),
            subtitle: Text(_currentLocale == 'fr' ? 'Français' : 'English'),
          ),
          RadioGroup<String>(
            groupValue: _currentLocale,
            onChanged: (v) {
              if (v != null) _changeLocale(v);
            },
            child: const Column(
              children: [
                RadioListTile<String>(
                  title: Text('Français'),
                  value: 'fr',
                ),
                RadioListTile<String>(
                  title: Text('English'),
                  value: 'en',
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.about),
            subtitle: const Text('UbuntuTech v1.1.0'),
          ),
        ],
      ),
    );
  }
}