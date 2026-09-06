import 'package:flutter/material.dart';
import '../sales/presentation/sales_screen.dart';
import '../products/presentation/products_screen.dart';
import '../debts/presentation/debts_screen.dart';
import '../auth/data/auth_repository.dart';
import '../auth/presentation/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _screens = const [SalesScreen(), ProductsScreen(), DebtsScreen()];
  final _authRepo = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Ventes', 'Stocks', 'Dettes'][_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authRepo.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Ventes'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Stocks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Dettes'),
        ],
      ),
    );
  }
}