import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../models/achievement_model.dart';

class LearningProvider extends ChangeNotifier {
  int _nivelActual = 1;
  int _puntosActuales = 0;
  final List<int> _leccionesCompletadas = [];
  final List<String> _insigniasDesbloqueadas = [];
  final Map<String, int> _quizScores = {};
  int _diasConsecutivos = 0;
  DateTime? _ultimoAcceso;
  int _saludFinanciera = 0;

  int get nivelActual => _nivelActual;
  int get puntosActuales => _puntosActuales;
  List<Leccion> get lecciones => LeccionesData.lecciones;
  List<String> get insigniasDesbloqueadas => _insigniasDesbloqueadas;
  Map<String, int> get quizScores => _quizScores;
  int get diasConsecutivos => _diasConsecutivos;
  int get saludFinanciera => _saludFinanciera;

  int get leccionesCompletadasCount => _leccionesCompletadas.length;

  void completarLeccion(int leccionId, int puntos, int quizScore) {
    if (!_leccionesCompletadas.contains(leccionId)) {
      _leccionesCompletadas.add(leccionId);
      _puntosActuales += puntos;
      _quizScores[leccionId.toString()] = quizScore;

      // Verificar insignias
      _verificarInsignias();

      while (_puntosActuales >= (_nivelActual * 300)) {
        _puntosActuales -= (_nivelActual * 300);
        _nivelActual++;
      }

      notifyListeners();
    }
  }

  void _verificarInsignias() {
    // Primer Paso
    if (_leccionesCompletadas.length >= 1 && !_insigniasDesbloqueadas.contains('primer_paso')) {
      _insigniasDesbloqueadas.add('primer_paso');
    }

    // Aprendiz
    if (_leccionesCompletadas.length >= 3 && !_insigniasDesbloqueadas.contains('aprendiz')) {
      _insigniasDesbloqueadas.add('aprendiz');
    }

    // Maestro de Finanzas
    if (_leccionesCompletadas.length >= 6 && !_insigniasDesbloqueadas.contains('maestro_finanzas')) {
      _insigniasDesbloqueadas.add('maestro_finanzas');
    }

    // Quiz Perfecto
    if (_quizScores.values.any((score) => score == 100) && !_insigniasDesbloqueadas.contains('quiz_perfecto')) {
      _insigniasDesbloqueadas.add('quiz_perfecto');
    }

    // Nivel 5
    if (_nivelActual >= 5 && !_insigniasDesbloqueadas.contains('nivel_5')) {
      _insigniasDesbloqueadas.add('nivel_5');
    }
  }

  void verificarInsigniaGastos(int totalGastos) {
    if (totalGastos >= 10 && !_insigniasDesbloqueadas.contains('organizador')) {
      _insigniasDesbloqueadas.add('organizador');
      notifyListeners();
    }
  }

  void verificarInsigniaMetas(int metasCreadas, int metasCompletadas) {
    if (metasCreadas >= 1 && !_insigniasDesbloqueadas.contains('ahorrador')) {
      _insigniasDesbloqueadas.add('ahorrador');
      notifyListeners();
    }

    if (metasCompletadas >= 1 && !_insigniasDesbloqueadas.contains('planificador')) {
      _insigniasDesbloqueadas.add('planificador');
      notifyListeners();
    }
  }

  void actualizarRacha() {
    final ahora = DateTime.now();

    if (_ultimoAcceso == null) {
      _diasConsecutivos = 1;
      _ultimoAcceso = ahora;
    } else {
      final diferencia = ahora.difference(_ultimoAcceso!).inDays;

      if (diferencia == 1) {
        // Día consecutivo
        _diasConsecutivos++;
      } else if (diferencia > 1) {
        // Perdió la racha
        _diasConsecutivos = 1;
      }
      // Si diferencia == 0, es el mismo día, no hacer nada

      _ultimoAcceso = ahora;
    }

    // Verificar insignia de racha
    if (_diasConsecutivos >= 7 && !_insigniasDesbloqueadas.contains('racha_7')) {
      _insigniasDesbloqueadas.add('racha_7');
    }

    notifyListeners();
  }

  void establecerSaludFinanciera(int puntos) {
    _saludFinanciera = puntos;
    notifyListeners();
  }

  bool isCompletada(int id) => _leccionesCompletadas.contains(id);

  double get progresoNivel {
    final necesarios = _nivelActual * 300;
    return (_puntosActuales / necesarios) * 100;
  }

  double get progresoGeneral {
    final maxLecciones = 6;
    final pesoLecciones = (_leccionesCompletadas.length / maxLecciones) * 40;
    final pesoInsignias = (_insigniasDesbloqueadas.length / 9) * 30;
    final pesoNivel = (_nivelActual >= 5 ? 20 : (_nivelActual / 5) * 20);
    final pesoSalud = (_saludFinanciera / 100) * 10;

    return pesoLecciones + pesoInsignias + pesoNivel + pesoSalud;
  }

  List<Insignia> get todasLasInsignias {
    return AchievementsData.insignias.map((insignia) {
      final desbloqueada = _insigniasDesbloqueadas.contains(insignia.id);
      return Insignia(
        id: insignia.id,
        nombre: insignia.nombre,
        descripcion: insignia.descripcion,
        icono: insignia.icono,
        color: insignia.color,
        desbloqueada: desbloqueada,
        fechaDesbloqueo: desbloqueada ? DateTime.now() : null,
      );
    }).toList();
  }
}