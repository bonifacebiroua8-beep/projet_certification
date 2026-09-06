import 'package:flutter/material.dart';
import '../data/debts_repository.dart';
import '../domain/debt_model.dart';
import 'add_debt_dialog.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});
  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final _repo = DebtsRepository();
  List<DebtModel> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final items = await _repo.getDebts();
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
            final d = _items[i];
            final reste = d.montant - d.montantRembourse;
            return ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: Text(d.client),
              trailing: Text('${reste.toStringAsFixed(0)} FCFA'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await showDialog<bool>(context: context, builder: (_) => const AddDebtDialog());
          if (added == true) _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}