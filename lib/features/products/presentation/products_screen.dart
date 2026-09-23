import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _repo.getProducts();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          semanticsLabel: 'Chargement du stock',
        ),
      );
    }
    if (_error != null) {
      return Semantics(
        label: 'Erreur de chargement du stock',
        child: Center(child: Text(t.loadStockError)),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: Semantics(
          label: 'Liste des produits en stock',
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, i) {
              final p = _items[i];
              final alerte = p.quantite <= p.seuilAlerte;
              return Semantics(
                label: alerte
                    ? 'Produit ${p.nom}, stock faible, ${p.quantite} restants'
                    : 'Produit ${p.nom}, ${p.quantite} en stock',
                child: ListTile(
                  leading: Icon(
                    Icons.inventory_2,
                    color: alerte ? Colors.orange : Colors.green,
                  ),
                  title: Text(p.nom),
                  subtitle: Text('${p.quantite} — ${p.prixUnitaire} FCFA/u'),
                  trailing: alerte
                      ? Text(t.lowStock,
                          style: const TextStyle(color: Colors.orange))
                      : null,
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.newProduct,
        onPressed: () async {
          final added = await showDialog<bool>(
            context: context,
            builder: (_) => const AddProductDialog(),
          );
          if (added == true && mounted) _load();
        },
        child: Semantics(
          label: t.newProduct,
          button: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
