import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';
import 'register_screen.dart';
import '../../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repo = AuthRepository();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final ok = await _repo.login(_email.text.trim(), _password.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (mounted) {
      setState(() => _error = AppLocalizations.of(context)!.loginFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Champ email',
              textField: true,
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: t.email),
              ),
            ),
            Semantics(
              label: 'Champ mot de passe',
              textField: true,
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(labelText: t.password),
              ),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Semantics(
                label: 'Erreur : $_error',
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Semantics(
              label: t.login,
              button: true,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(
                        semanticsLabel: 'Connexion en cours',
                      )
                    : Text(t.login),
              ),
            ),
            Semantics(
              label: t.register,
              button: true,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: Text(t.register),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
