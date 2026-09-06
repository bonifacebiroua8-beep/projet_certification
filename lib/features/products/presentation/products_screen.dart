import 'package:flutter/material.dart';
import '../data/products_repository.dart';
import '../domain/product_model.dart';
import 'add_product_dialog.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _repo = ProductsRepository();
  List<ProductModel> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final items = await _repo.getProducts();
      setState(() { _items = items; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, i) {
            final p = _items[i];
            final alerte = p.quantite <= p.seuilAlerte;
            return ListTile(
              leading: Icon(Icons.inventory_2, color: alerte ? Colors.orange : Colors.green),
              title: Text(p.nom),
              subtitle: Text('${p.quantite} en stock — ${p.prixUnitaire} FCFA/u'),
              trailing: alerte ? const Text('Stock faible', style: TextStyle(color: Colors.orange)) : null,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await showDialog<bool>(context: context, builder: (_) => const AddProductDialog());
          if (added == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}