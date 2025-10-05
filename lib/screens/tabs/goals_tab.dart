import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';

class GoalsTab extends StatelessWidget {
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final finance = Provider.of<FinanceProvider>(context);
    final fmt = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Metas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => _showAddGoalDialog(context),
          ),
        ],
      ),
      body: finance.metas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flag, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text('No tienes metas de ahorro', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Text('Toca el botón + para crear una', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => finance.loadMetas(auth.user!['id']),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: finance.metas.length,
                itemBuilder: (context, index) {
                  final meta = finance.metas[index];
                  final nombre = meta['nombre'] as String;
                  final objetivo = (meta['monto_objetivo'] as num).toDouble();
                  final actual = (meta['monto_actual'] as num).toDouble();
                  final completada = meta['completada'] as bool;
                  
                  // Definir explícitamente como double
                  final double progreso = objetivo > 0.0 ? (actual / objetivo) : 0.0;
                  final double porcentajeDisplay = progreso > 1.0 ? 1.0 : progreso;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                completada ? Icons.check_circle : Icons.flag, 
                                color: completada ? Colors.green : const Color(0xFF00BFA5), 
                                size: 30
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  nombre, 
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return LinearPercentIndicator(
                                width: constraints.maxWidth,
                                lineHeight: 20.0,
                                percent: porcentajeDisplay,
                                center: Text(
                                  '${(progreso * 100.0).toStringAsFixed(0)}%',
                                  style: const TextStyle(fontSize: 12, color: Colors.white),
                                ),
                                progressColor: completada ? Colors.green : const Color(0xFF00BFA5),
                                backgroundColor: Colors.grey[300],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Actual: ${fmt.format(actual)}'),
                              Text(
                                'Meta: ${fmt.format(objetivo)}', 
                                style: const TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                          if (!completada) ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => _showUpdateProgressDialog(context, meta),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Ahorro'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00BFA5)
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    
    final nombreController = TextEditingController();
    final montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Meta de Ahorro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la meta', 
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
                labelText: 'Monto objetivo (S/.)', 
                border: OutlineInputBorder()
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancelar')
          ),
          ElevatedButton(
            onPressed: () async {
              if (nombreController.text.isEmpty || montoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completa todos los campos'), 
                    backgroundColor: Colors.red
                  ),
                );
                return;
              }

              final success = await finance.addMeta(
                auth.user!['id'],
                nombreController.text,
                double.parse(montoController.text),
                null,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Meta creada' : 'Error'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showUpdateProgressDialog(BuildContext context, Map<String, dynamic> meta) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    
    final montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Ahorro'),
        content: TextField(
          controller: montoController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
          ],
          decoration: const InputDecoration(
            labelText: 'Monto a agregar (S/.)', 
            border: OutlineInputBorder()
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancelar')
          ),
          ElevatedButton(
            onPressed: () async {
              if (montoController.text.isEmpty) return;

              final actual = (meta['monto_actual'] as num).toDouble();
              final nuevoMonto = actual + double.parse(montoController.text);

              final success = await finance.updateMetaProgress(
                auth.user!['id'],
                meta['id'],
                nuevoMonto,
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Progreso actualizado' : 'Error'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}