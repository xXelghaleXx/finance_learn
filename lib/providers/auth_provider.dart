import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  final _db = DatabaseService.instance;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      _user = {
        'id': userId,
        'nombre': prefs.getString('user_nombre') ?? '',
        'email': prefs.getString('user_email') ?? '',
        'salario_mensual': prefs.getDouble('user_salario') ?? 0.0,
        'nivel_educativo': prefs.getInt('user_nivel') ?? 1,
        'puntos_totales': prefs.getInt('user_puntos') ?? 0,
      };
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final userData = await _db.login(email, password);

    if (userData != null) {
      _user = userData;
      await _saveUserData(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Email o contraseña incorrectos';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String nombre, String email, String password, double salario) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final userData = await _db.register(nombre, email, password, salario);

    if (userData != null) {
      _user = userData;
      await _saveUserData(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Error al registrar. El email puede estar en uso.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('user_nombre', userData['nombre']);
    await prefs.setString('user_email', userData['email']);
    await prefs.setDouble('user_salario', (userData['salario_mensual'] as num).toDouble());
    await prefs.setInt('user_nivel', userData['nivel_educativo']);
    await prefs.setInt('user_puntos', userData['puntos_totales']);
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  void updatePuntos(int puntos) {
    if (_user != null) {
      _user!['puntos_totales'] = (_user!['puntos_totales'] ?? 0) + puntos;
      _saveUserData(_user!);
      notifyListeners();
    }
  }
}