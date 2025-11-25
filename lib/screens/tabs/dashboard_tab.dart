import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/learning_provider.dart';
import '../progress_screen.dart';
import '../financial_health_assessment_screen.dart';
import '../chatbot_screen.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final finance = Provider.of<FinanceProvider>(context);
    final learning = Provider.of<LearningProvider>(context);
    final fmt = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);

    final salario = (auth.user?['salario_mensual'] as num?)?.toDouble() ?? 0;
    final gastos = finance.totalGastos;
    final disponible = salario - gastos;
    final porcentaje = salario > 0 ? (gastos / salario) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${auth.user?['nombre'] ?? 'Usuario'}'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Chip(
              avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
              label: Text('Nivel ${learning.nivelActual}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = auth.user!['id'];
          await Future.wait([
            finance.loadGastos(userId),
            finance.loadMetas(userId),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resumen Financiero', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Ingresos', fmt.format(salario), Icons.arrow_downward, Colors.green),
                          _buildStat('Gastos', fmt.format(gastos), Icons.arrow_upward, Colors.red),
                          _buildStat('Disponible', fmt.format(disponible), Icons.account_balance_wallet, const Color(0xFF00BFA5)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: porcentaje / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(porcentaje > 80 ? Colors.red : const Color(0xFF00BFA5)),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text('Has gastado ${porcentaje.toStringAsFixed(1)}% de tu salario', 
                        style: TextStyle(color: porcentaje > 80 ? Colors.red : Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              if (finance.gastosPorCategoria.isNotEmpty) ...[
                const Text('Gastos por Categoría', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: finance.gastosPorCategoria.entries.take(5).map((e) {
                        final porcentajeCat = gastos > 0 ? (e.value / gastos) * 100 : 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(FinanceProvider.categoriasIconos[e.key], color: const Color(0xFF00BFA5)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(value: porcentajeCat / 100, minHeight: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(fmt.format(e.value), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              
              const Text('Tu Progreso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 50,
                        lineWidth: 10,
                        percent: learning.progresoNivel / 100,
                        center: Text('${learning.progresoNivel.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        progressColor: const Color(0xFF00BFA5),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nivel ${learning.nivelActual}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('${learning.puntosActuales} / ${learning.nivelActual * 300} puntos', style: TextStyle(color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Text('Sigue aprendiendo para subir de nivel', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Botones de acceso rápido
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProgressScreen()),
                        );
                      },
                      icon: const Icon(Icons.analytics, color: Colors.white),
                      label: const Text('Ver Progreso', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FinancialHealthAssessmentScreen()),
                        );
                      },
                      icon: const Icon(Icons.health_and_safety, color: Colors.white),
                      label: const Text('Evaluar Salud', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatBotScreen()),
    );
  },
  icon: const Icon(Icons.chat, color: Colors.white),
  label: const Text('Hablar con FinnChatBot', style: TextStyle(color: Colors.white)),
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF00BFA5),
    padding: const EdgeInsets.symmetric(vertical: 14),
  ),
),

              const SizedBox(height: 20),

              Card(
                color: const Color(0xFF00BFA5).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb, color: Color(0xFF00BFA5), size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Consejo del Día', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Ahorra al menos el 20% de tus ingresos mensuales para construir tu fondo de emergencia.',
                              style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}