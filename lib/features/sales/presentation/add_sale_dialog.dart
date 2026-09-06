import 'package:flutter/material.dart';
import '../data/sales_repository.dart';
import '../../products/data/products_repository.dart';
import '../../products/domain/product_model.dart';
import '../../../core/error/app_exception.dart';

class AddSaleDialog extends StatefulWidget {
  const AddSaleDialog({super.key});
  @override
  State<AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<AddSaleDialog> {
  final _repo = SalesRepository();
  final _productsRepo = ProductsRepository();
  final _qty = TextEditingController();
  final _price = TextEditingController();
  final _client = TextEditingController();
  List<ProductModel> _products = [];
  String? _selectedProductId;
  bool _loading = false;
  String? _error;

  @override
  void initState() { super.initState(); _loadProducts(); }

  Future<void> _loadProducts() async {
    final p = await _productsRepo.getProducts();
    setState(() => _products = p);
  }

  Future<void> _submit() async {
    if (_selectedProductId == null || _qty.text.isEmpty || _price.text.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      await _repo.addSale(_selectedProductId!, double.parse(_qty.text),
          double.parse(_price.text), _client.text);
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
      title: const Text('Nouvelle vente'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        DropdownButtonFormField<String>(
          value: _selectedProductId,
          hint: const Text('Produit'),
          items: _products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom))).toList(),
          onChanged: (v) => setState(() => _selectedProductId = v),
        ),
        TextField(controller: _qty, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantité')),
        TextField(controller: _price, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Prix unitaire')),
        TextField(controller: _client, decoration: const InputDecoration(labelText: 'Client (optionnel)')),
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