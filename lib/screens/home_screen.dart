import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/finance_provider.dart';
import '../providers/learning_provider.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/expenses_tab.dart';
import 'tabs/learn_tab.dart';
import 'tabs/goals_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    DashboardTab(),
    ExpensesTab(),
    LearnTab(),
    GoalsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final financeProvider = Provider.of<FinanceProvider>(context, listen: false);
    final learningProvider = Provider.of<LearningProvider>(context, listen: false);

    if (authProvider.user != null) {
      final userId = authProvider.user!['id'];

      // Actualizar racha diaria
      learningProvider.actualizarRacha();

      // Cargar datos
      await Future.wait([
        financeProvider.loadGastos(userId),
        financeProvider.loadMetas(userId),
      ]);

      // Verificar insignias de gastos y metas
      learningProvider.verificarInsigniaGastos(financeProvider.gastos.length);
      learningProvider.verificarInsigniaMetas(
        financeProvider.metas.length,
        financeProvider.metas.where((m) => m['completada'] as bool).length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00BFA5),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Gastos'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Aprender'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Metas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}