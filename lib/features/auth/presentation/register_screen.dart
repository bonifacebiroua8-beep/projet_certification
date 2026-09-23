import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repo = AuthRepository();
  bool _loading = false;
  String? _message;

  Future<void> _submit() async {
    setState(() { _loading = true; _message = null; });
    final ok = await _repo.register(_email.text.trim(), _password.text);
    setState(() {
      _loading = false;
      _message = ok ? AppLocalizations.of(context)!.accountCreated : AppLocalizations.of(context)!.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.register)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: t.email)),
          TextField(controller: _password, obscureText: true, decoration: InputDecoration(labelText: t.password)),
          const SizedBox(height: 16),
          if (_message != null) Text(_message!),
          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: _loading ? const CircularProgressIndicator() : Text(t.register),
          ),
        ]),
      ),
    );
  }
}