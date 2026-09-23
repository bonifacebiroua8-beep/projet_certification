import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _repo.addDebt(_client.text, double.parse(_montant.text));
      if (mounted) Navigator.pop(context, true);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(t.newDebt),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _client,
              decoration: InputDecoration(labelText: t.client),
            ),
            TextField(
              controller: _montant,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.amount),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const CircularProgressIndicator()
              : Text(t.save),
        ),
      ],
    );
  }
}