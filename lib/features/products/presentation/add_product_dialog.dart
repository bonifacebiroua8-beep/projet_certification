import 'package:flutter/material.dart';
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
    setState(() { _loading = true; _error = null; });
    try {
      await _repo.addProduct(_nom.text, double.parse(_qty.text),
          double.parse(_price.text), double.parse(_seuil.text));
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
      title: const Text('Nouveau produit'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom')),
        TextField(controller: _qty, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantité')),
        TextField(controller: _price, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Prix unitaire')),
        TextField(controller: _seuil, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Seuil alerte')),
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