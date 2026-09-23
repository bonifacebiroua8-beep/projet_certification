import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../data/products_repository.dart';
import '../../../core/error/app_exception.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});
  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _repo = ProductsRepository();
  final _nom = TextEditingController();
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _seuil = TextEditingController(text: '5');
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (_nom.text.isEmpty || _qty.text.isEmpty || _price.text.isEmpty) return;
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _repo.addProduct(
        _nom.text,
        double.parse(_qty.text),
        double.parse(_price.text),
        double.parse(_seuil.text),
      );
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
      title: Text(t.newProduct),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nom,
              decoration: InputDecoration(labelText: t.name),
            ),
            TextField(
              controller: _qty,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.quantity),
            ),
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.unitPrice),
            ),
            TextField(
              controller: _seuil,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.alertThreshold),
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