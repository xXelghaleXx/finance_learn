import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final finance = Provider.of<FinanceProvider>(context);
    final fmt = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => _showAddExpenseDialog(context),
          ),
        ],
      ),
      body: finance.gastos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text('No hay gastos registrados', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  const SizedBox(height: 10),
                  Text('Toca el botón + para agregar', style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => finance.loadGastos(auth.user!['id']),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: finance.gastos.length,
                itemBuilder: (context, index) {
                  final gasto = finance.gastos[index];
                  final categoria = gasto['categoria'] as String;
                  final monto = (gasto['monto'] as num).toDouble();
                  final desc = gasto['descripcion'] as String;
                  final fecha = gasto['fecha'] as DateTime;
                  final recurrente = gasto['es_recurrente'] as bool;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF00BFA5),
                        child: Icon(FinanceProvider.categoriasIconos[categoria], color: Colors.white),
                      ),
                      title: Text(categoria, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(desc),
                          const SizedBox(height: 4),
                          Text(dateFmt.format(fecha), style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(fmt.format(monto), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                          if (recurrente) const Text('Recurrente', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final finance = Provider.of<FinanceProvider>(context, listen: false);
    
    String? selectedCategoria;
    final montoController = TextEditingController();
    final descController = TextEditingController();
    bool esRecurrente = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Agregar Gasto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                  items: FinanceProvider.categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => selectedCategoria = value,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  decoration: const InputDecoration(labelText: 'Monto (S/.)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descripción', border: OutlineInputBorder()),
                ),
                CheckboxListTile(
                  title: const Text('Gasto Recurrente'),
                  value: esRecurrente,
                  onChanged: (value) => setState(() => esRecurrente = value ?? false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (selectedCategoria == null || montoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.red),
                  );
                  return;
                }

                final success = await finance.addGasto(
                  auth.user!['id'],
                  selectedCategoria!,
                  double.parse(montoController.text),
                  descController.text,
                  esRecurrente,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Gasto agregado' : 'Error'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}