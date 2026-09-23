import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
      final items = await _repo.getDebts();
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
          semanticsLabel: 'Chargement des dettes',
        ),
      );
    }
    if (_error != null) {
      return Semantics(
        label: 'Erreur de chargement des dettes',
        child: Center(child: Text(t.loadDebtsError)),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: Semantics(
          label: 'Liste des dettes clients',
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, i) {
              final d = _items[i];
              final reste = d.montant - d.montantRembourse;
              return Semantics(
                label: 'Dette de ${d.client}, $reste francs restants',
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.purple),
                  title: Text(d.client),
                  trailing: Text('${reste.toStringAsFixed(0)} FCFA'),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.newDebt,
        onPressed: () async {
          final added = await showDialog<bool>(
            context: context,
            builder: (_) => const AddDebtDialog(),
          );
          if (added == true && mounted) _load();
        },
        child: Semantics(
          label: t.newDebt,
          button: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
