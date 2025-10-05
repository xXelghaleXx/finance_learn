import 'package:flutter/material.dart';
import '../services/database_service.dart';

class FinanceProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _gastos = [];
  List<Map<String, dynamic>> _metas = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get gastos => _gastos;
  List<Map<String, dynamic>> get metas => _metas;
  bool get isLoading => _isLoading;

  final _db = DatabaseService.instance;

  static const List<String> categorias = [
    'Alimentación',
    'Transporte',
    'Vivienda',
    'Educación',
    'Entretenimiento',
    'Salud',
    'Ropa',
    'Otros',
  ];

  static const Map<String, IconData> categoriasIconos = {
    'Alimentación': Icons.restaurant,
    'Transporte': Icons.directions_bus,
    'Vivienda': Icons.home,
    'Educación': Icons.school,
    'Entretenimiento': Icons.movie,
    'Salud': Icons.medical_services,
    'Ropa': Icons.checkroom,
    'Otros': Icons.category,
  };

  Future<void> loadGastos(int userId) async {
    _isLoading = true;
    notifyListeners();
    _gastos = await _db.getGastos(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addGasto(int userId, String cat, double monto, String desc, bool recur) async {
    final success = await _db.addGasto(userId, cat, monto, desc, recur);
    if (success) await loadGastos(userId);
    return success;
  }

  Future<void> loadMetas(int userId) async {
    _isLoading = true;
    notifyListeners();
    _metas = await _db.getMetas(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addMeta(int userId, String nombre, double monto, DateTime? fecha) async {
    final success = await _db.addMeta(userId, nombre, monto, fecha);
    if (success) await loadMetas(userId);
    return success;
  }

  Future<bool> updateMetaProgress(int userId, int metaId, double nuevoMonto) async {
    final success = await _db.updateMetaProgress(metaId, nuevoMonto);
    if (success) await loadMetas(userId);
    return success;
  }

  double get totalGastos => _gastos.fold(0.0, (sum, g) => sum + ((g['monto'] as num).toDouble()));

  Map<String, double> get gastosPorCategoria {
    final Map<String, double> result = {};
    for (var g in _gastos) {
      final cat = g['categoria'] as String;
      final monto = (g['monto'] as num).toDouble();
      result[cat] = (result[cat] ?? 0) + monto;
    }
    return result;
  }
}