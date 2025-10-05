import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<void> initializeDatabase() async {
    if (!kIsWeb) {
      await _getDatabase();
      print('✅ SQLite inicializado (móvil/desktop)');
    } else {
      print('✅ SharedPreferences inicializado (web)');
    }
  }

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    
    String path = join(await getDatabasesPath(), 'finance_learn.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            salario_mensual REAL DEFAULT 0,
            nivel_educativo INTEGER DEFAULT 1,
            puntos_totales INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE gastos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            categoria TEXT NOT NULL,
            monto REAL NOT NULL,
            descripcion TEXT,
            fecha TEXT NOT NULL,
            es_recurrente INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE metas_ahorro (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            nombre TEXT NOT NULL,
            monto_objetivo REAL NOT NULL,
            monto_actual REAL DEFAULT 0,
            fecha_objetivo TEXT,
            completada INTEGER DEFAULT 0
          )
        ''');
      },
    );
    return _database!;
  }

  // ========== LOGIN ==========
  Future<Map<String, dynamic>?> login(String email, String password) async {
    if (kIsWeb) {
      return _loginWeb(email, password);
    } else {
      return _loginMobile(email, password);
    }
  }

  Future<Map<String, dynamic>?> _loginWeb(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final List users = jsonDecode(usersJson);

    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        return Map<String, dynamic>.from(user);
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _loginMobile(String email, String password) async {
    final db = await _getDatabase();
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isEmpty ? null : result.first;
  }

  // ========== REGISTER ==========
  Future<Map<String, dynamic>?> register(String nombre, String email, String password, double salario) async {
    if (kIsWeb) {
      return _registerWeb(nombre, email, password, salario);
    } else {
      return _registerMobile(nombre, email, password, salario);
    }
  }

  Future<Map<String, dynamic>?> _registerWeb(String nombre, String email, String password, double salario) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users') ?? '[]';
    final List users = jsonDecode(usersJson);

    for (var user in users) {
      if (user['email'] == email) return null;
    }

    final newUser = {
      'id': users.length + 1,
      'nombre': nombre,
      'email': email,
      'password': password,
      'salario_mensual': salario,
      'nivel_educativo': 1,
      'puntos_totales': 0,
    };

    users.add(newUser);
    await prefs.setString('users', jsonEncode(users));
    return newUser;
  }

  Future<Map<String, dynamic>?> _registerMobile(String nombre, String email, String password, double salario) async {
    final db = await _getDatabase();
    
    final exists = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (exists.isNotEmpty) return null;

    final id = await db.insert('usuarios', {
      'nombre': nombre,
      'email': email,
      'password': password,
      'salario_mensual': salario,
      'nivel_educativo': 1,
      'puntos_totales': 0,
    });

    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'salario_mensual': salario,
      'nivel_educativo': 1,
      'puntos_totales': 0,
    };
  }

  // ========== GASTOS ==========
  Future<List<Map<String, dynamic>>> getGastos(int usuarioId) async {
    if (kIsWeb) {
      return _getGastosWeb(usuarioId);
    } else {
      return _getGastosMobile(usuarioId);
    }
  }

  Future<List<Map<String, dynamic>>> _getGastosWeb(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final gastosJson = prefs.getString('gastos_$usuarioId') ?? '[]';
    final List gastos = jsonDecode(gastosJson);
    
    return gastos.map((g) => {
      'id': g['id'],
      'categoria': g['categoria'],
      'monto': g['monto'],
      'descripcion': g['descripcion'],
      'fecha': DateTime.parse(g['fecha']),
      'es_recurrente': g['es_recurrente'],
    }).cast<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> _getGastosMobile(int usuarioId) async {
    final db = await _getDatabase();
    final result = await db.query(
      'gastos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'fecha DESC',
    );

    return result.map((g) => {
      'id': g['id'],
      'categoria': g['categoria'],
      'monto': g['monto'],
      'descripcion': g['descripcion'],
      'fecha': DateTime.parse(g['fecha'] as String),
      'es_recurrente': g['es_recurrente'] == 1,
    }).toList();
  }

  Future<bool> addGasto(int userId, String cat, double monto, String desc, bool recur) async {
    if (kIsWeb) {
      return _addGastoWeb(userId, cat, monto, desc, recur);
    } else {
      return _addGastoMobile(userId, cat, monto, desc, recur);
    }
  }

  Future<bool> _addGastoWeb(int userId, String cat, double monto, String desc, bool recur) async {
    final prefs = await SharedPreferences.getInstance();
    final gastosJson = prefs.getString('gastos_$userId') ?? '[]';
    final List gastos = jsonDecode(gastosJson);

    gastos.add({
      'id': gastos.length + 1,
      'categoria': cat,
      'monto': monto,
      'descripcion': desc,
      'fecha': DateTime.now().toIso8601String(),
      'es_recurrente': recur,
    });

    await prefs.setString('gastos_$userId', jsonEncode(gastos));
    return true;
  }

  Future<bool> _addGastoMobile(int userId, String cat, double monto, String desc, bool recur) async {
    final db = await _getDatabase();
    await db.insert('gastos', {
      'usuario_id': userId,
      'categoria': cat,
      'monto': monto,
      'descripcion': desc,
      'fecha': DateTime.now().toIso8601String(),
      'es_recurrente': recur ? 1 : 0,
    });
    return true;
  }

  // ========== METAS ==========
  Future<List<Map<String, dynamic>>> getMetas(int usuarioId) async {
    if (kIsWeb) {
      return _getMetasWeb(usuarioId);
    } else {
      return _getMetasMobile(usuarioId);
    }
  }

  Future<List<Map<String, dynamic>>> _getMetasWeb(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final metasJson = prefs.getString('metas_$usuarioId') ?? '[]';
    final List metas = jsonDecode(metasJson);
    
    return metas.map((m) => {
      'id': m['id'],
      'nombre': m['nombre'],
      'monto_objetivo': m['monto_objetivo'],
      'monto_actual': m['monto_actual'],
      'fecha_objetivo': m['fecha_objetivo'] != null ? DateTime.parse(m['fecha_objetivo']) : null,
      'completada': m['completada'],
    }).cast<Map<String, dynamic>>().toList();
  }

  Future<List<Map<String, dynamic>>> _getMetasMobile(int usuarioId) async {
    final db = await _getDatabase();
    final result = await db.query(
      'metas_ahorro',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
    );

    return result.map((m) => {
      'id': m['id'],
      'nombre': m['nombre'],
      'monto_objetivo': m['monto_objetivo'],
      'monto_actual': m['monto_actual'],
      'fecha_objetivo': m['fecha_objetivo'] != null ? DateTime.parse(m['fecha_objetivo'] as String) : null,
      'completada': m['completada'] == 1,
    }).toList();
  }

  Future<bool> addMeta(int userId, String nombre, double monto, DateTime? fecha) async {
    if (kIsWeb) {
      return _addMetaWeb(userId, nombre, monto, fecha);
    } else {
      return _addMetaMobile(userId, nombre, monto, fecha);
    }
  }

  Future<bool> _addMetaWeb(int userId, String nombre, double monto, DateTime? fecha) async {
    final prefs = await SharedPreferences.getInstance();
    final metasJson = prefs.getString('metas_$userId') ?? '[]';
    final List metas = jsonDecode(metasJson);

    metas.add({
      'id': metas.length + 1,
      'nombre': nombre,
      'monto_objetivo': monto,
      'monto_actual': 0.0,
      'fecha_objetivo': fecha?.toIso8601String(),
      'completada': false,
    });

    await prefs.setString('metas_$userId', jsonEncode(metas));
    return true;
  }

  Future<bool> _addMetaMobile(int userId, String nombre, double monto, DateTime? fecha) async {
    final db = await _getDatabase();
    await db.insert('metas_ahorro', {
      'usuario_id': userId,
      'nombre': nombre,
      'monto_objetivo': monto,
      'monto_actual': 0.0,
      'fecha_objetivo': fecha?.toIso8601String(),
      'completada': 0,
    });
    return true;
  }

  Future<bool> updateMetaProgress(int metaId, double nuevoMonto) async {
    if (kIsWeb) {
      return true;
    } else {
      final db = await _getDatabase();
      await db.update(
        'metas_ahorro',
        {'monto_actual': nuevoMonto},
        where: 'id = ?',
        whereArgs: [metaId],
      );
      return true;
    }
  }
}