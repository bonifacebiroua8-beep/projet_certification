import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
      final items = await _repo.getSales();
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
          semanticsLabel: 'Chargement des ventes',
        ),
      );
    }
    if (_error != null) {
      return Semantics(
        label: 'Erreur de chargement des ventes',
        child: Center(child: Text(t.loadSalesError)),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: Semantics(
          label: 'Liste des ventes',
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, i) {
              final s = _items[i];
              return Semantics(
                label:
                    'Vente de ${s.quantite} ${s.prixUnitaire} francs, total ${s.montantTotal} francs',
                child: ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Colors.green),
                  title: Text('${s.quantite} × ${s.prixUnitaire} FCFA'),
                  subtitle: Text(
                    s.client.isEmpty
                        ? s.modePaiement
                        : '${s.client} — ${s.modePaiement}',
                  ),
                  trailing: Text(
                    '+${s.montantTotal.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.newSale,
        onPressed: () async {
          final added = await showDialog<bool>(
            context: context,
            builder: (_) => const AddSaleDialog(),
          );
          if (added == true && mounted) _load();
        },
        child: Semantics(
          label: t.newSale,
          button: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
