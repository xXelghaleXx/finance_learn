import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/learning_provider.dart';
import '../login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final learning = Provider.of<LearningProvider>(context);
    final fmt = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF00BFA5),
              child: Text(
                (auth.user?['nombre'] as String?)?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(auth.user?['nombre'] ?? 'Usuario', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(auth.user?['email'] ?? '', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 30),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text('Nivel'),
                    trailing: Text('Nivel ${learning.nivelActual}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.emoji_events, color: Colors.orange),
                    title: const Text('Puntos Totales'),
                    trailing: Text('${auth.user?['puntos_totales'] ?? 0} pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.attach_money, color: Colors.green),
                    title: const Text('Salario Mensual'),
                    trailing: Text(
                      fmt.format((auth.user?['salario_mensual'] as num?)?.toDouble() ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}