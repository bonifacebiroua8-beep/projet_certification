import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userId;
  final _authRepo = AuthRepository();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final id = await SecureStorage.getUserId();
    setState(() => _userId = id);
  }

  Future<void> _logout() async {
    await _authRepo.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.profile)),
      body: ListView(
        children: [
          const SizedBox(height: 24),
          const Center(
            child: CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 48),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _userId == null ? '...' : 'ID: ${_userId!.substring(0, 8)}...',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(t.settings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(t.logout, style: const TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}