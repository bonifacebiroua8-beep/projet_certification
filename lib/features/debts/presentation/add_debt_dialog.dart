import 'package:flutter/material.dart';
import '../data/debts_repository.dart';
import '../../../core/error/app_exception.dart';

class AddDebtDialog extends StatefulWidget {
  const AddDebtDialog({super.key});
  @override
  State<AddDebtDialog> createState() => _AddDebtDialogState();
}

class _AddDebtDialogState extends State<AddDebtDialog> {
  final _repo = DebtsRepository();
  final _client = TextEditingController();
  final _montant = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (_client.text.isEmpty || _montant.text.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      await _repo.addDebt(_client.text, double.parse(_montant.text));
      if (mounted) Navigator.pop(context, true);
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle dette'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _client, decoration: const InputDecoration(labelText: 'Client')),
        TextField(controller: _montant, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Montant')),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
        ElevatedButton(onPressed: _loading ? null : _submit,
            child: _loading ? const CircularProgressIndicator() : const Text('Enregistrer')),
      ],
    );
  }
}