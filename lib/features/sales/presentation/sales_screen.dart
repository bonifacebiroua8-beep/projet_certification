import 'package:flutter/material.dart';
import '../data/sales_repository.dart';
import '../domain/sale_model.dart';
import 'add_sale_dialog.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _repo = SalesRepository();
  List<SaleModel> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final items = await _repo.getSales();
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
            final s = _items[i];
            return ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.green),
              title: Text('${s.quantite} × ${s.prixUnitaire} FCFA'),
              subtitle: Text(s.client.isEmpty ? s.modePaiement : '${s.client} — ${s.modePaiement}'),
              trailing: Text('+${s.montantTotal.toStringAsFixed(0)} FCFA',
                  style: const TextStyle(color: Colors.green)),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await showDialog<bool>(context: context, builder: (_) => const AddSaleDialog());
          if (added == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}