import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  String? _filtroCategoria;
  String _ordenamiento = 'fecha_desc';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final finance = Provider.of<FinanceProvider>(context);
    final fmt = NumberFormat.currency(symbol: 'S/. ', decimalDigits: 2);
    final dateFmt = DateFormat('dd/MM/yyyy HH:mm');

    // Filtrar y ordenar gastos
    var gastosFiltrados = finance.gastos.where((gasto) {
      if (_filtroCategoria != null && gasto['categoria'] != _filtroCategoria) {
        return false;
      }
      return true;
    }).toList();

    // Ordenar
    gastosFiltrados.sort((a, b) {
      switch (_ordenamiento) {
        case 'fecha_desc':
          return (b['fecha'] as DateTime).compareTo(a['fecha'] as DateTime);
        case 'fecha_asc':
          return (a['fecha'] as DateTime).compareTo(b['fecha'] as DateTime);
        case 'monto_desc':
          return (b['monto'] as num).compareTo(a['monto'] as num);
        case 'monto_asc':
          return (a['monto'] as num).compareTo(b['monto'] as num);
        default:
          return 0;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Gastos'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filtroCategoria = value == 'todas' ? null : value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'todas', child: Text('Todas las categorías')),
              const PopupMenuDivider(),
              ...FinanceProvider.categorias.map((cat) => PopupMenuItem(value: cat, child: Text(cat))),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _ordenamiento = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'fecha_desc', child: Text('Más recientes')),
              PopupMenuItem(value: 'fecha_asc', child: Text('Más antiguos')),
              PopupMenuItem(value: 'monto_desc', child: Text('Mayor monto')),
              PopupMenuItem(value: 'monto_asc', child: Text('Menor monto')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () => _showAddExpenseDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_filtroCategoria != null)
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20),
                  const SizedBox(width: 8),
                  Text('Filtrado por: $_filtroCategoria'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filtroCategoria = null;
                      });
                    },
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: gastosFiltrados.isEmpty
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
                itemCount: gastosFiltrados.length,
                itemBuilder: (context, index) {
                  final gasto = gastosFiltrados[index];
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(fmt.format(monto), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                              if (recurrente) const Text('Recurrente', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditExpenseDialog(context, gasto);
                              } else if (value == 'delete') {
                                _confirmDelete(context, gasto['id']);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Editar')])),
                              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Eliminar', style: TextStyle(color: Colors.red))])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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

  void _confirmDelete(BuildContext context, int gastoId) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que deseas eliminar este gasto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await finance.deleteGasto(gastoId, auth.user!['id']);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Gasto eliminado' : 'Error al eliminar'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditExpenseDialog(BuildContext context, Map<String, dynamic> gasto) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final finance = Provider.of<FinanceProvider>(context, listen: false);

    String selectedCategoria = gasto['categoria'];
    final montoController = TextEditingController(text: gasto['monto'].toString());
    final descController = TextEditingController(text: gasto['descripcion']);
    bool esRecurrente = gasto['es_recurrente'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Gasto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategoria,
                  decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                  items: FinanceProvider.categorias.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (value) => selectedCategoria = value!,
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
                if (montoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completa todos los campos'), backgroundColor: Colors.red),
                  );
                  return;
                }

                final success = await finance.updateGasto(
                  gasto['id'],
                  auth.user!['id'],
                  selectedCategoria,
                  double.parse(montoController.text),
                  descController.text,
                  esRecurrente,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Gasto actualizado' : 'Error'),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}