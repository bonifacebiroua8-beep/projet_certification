import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../sales/presentation/sales_screen.dart';
import '../products/presentation/products_screen.dart';
import '../debts/presentation/debts_screen.dart';
import '../profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _screens = const [
    SalesScreen(),
    ProductsScreen(),
    DebtsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final titles = [t.sales, t.stock, t.debts, t.profile];

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: titles[_index],
          child: Text(titles[_index]),
        ),
      ),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Semantics(
              label: t.sales,
              button: true,
              child: const Icon(Icons.shopping_cart),
            ),
            label: t.sales,
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: t.stock,
              button: true,
              child: const Icon(Icons.inventory_2),
            ),
            label: t.stock,
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: t.debts,
              button: true,
              child: const Icon(Icons.person),
            ),
            label: t.debts,
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: t.profile,
              button: true,
              child: const Icon(Icons.account_circle),
            ),
            label: t.profile,
          ),
        ],
      ),
    );
  }
}
