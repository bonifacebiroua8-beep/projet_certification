import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final p = await _productsRepo.getProducts();
      if (!mounted) return;
      setState(() => _products = p);
    } catch (_) {
      if (!mounted) return;
      setState(() => _products = []);
    }
  }

  Future<void> _submit() async {
    if (_selectedProductId == null || _qty.text.isEmpty || _price.text.isEmpty) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _repo.addSale(
        _selectedProductId!,
        double.parse(_qty.text),
        double.parse(_price.text),
        _client.text,
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
      title: Text(t.newSale),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _selectedProductId,
              hint: Text(t.product),
              items: _products
                  .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedProductId = v),
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
              controller: _client,
              decoration: InputDecoration(labelText: t.client),
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