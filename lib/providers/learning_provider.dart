import 'package:flutter/material.dart';

class LearningProvider extends ChangeNotifier {
  int _nivelActual = 1;
  int _puntosActuales = 0;
  final List<int> _leccionesCompletadas = [];

  int get nivelActual => _nivelActual;
  int get puntosActuales => _puntosActuales;

  static final List<Map<String, dynamic>> lecciones = [
    {
      'id': 1,
      'titulo': 'Introducción a las Finanzas',
      'nivel': 1,
      'puntos': 50,
      'duracion': '5 min',
      'descripcion': 'Aprende los conceptos básicos de finanzas personales y por qué son importantes para tu futuro.',
    },
    {
      'id': 2,
      'titulo': 'Creando tu Presupuesto',
      'nivel': 1,
      'puntos': 75,
      'duracion': '7 min',
      'descripcion': 'Descubre cómo crear un presupuesto mensual efectivo usando la regla 50/30/20.',
    },
    {
      'id': 3,
      'titulo': 'El Poder del Interés Compuesto',
      'nivel': 2,
      'puntos': 100,
      'duracion': '8 min',
      'descripcion': 'Entiende cómo el interés compuesto puede multiplicar tus ahorros con el tiempo.',
    },
    {
      'id': 4,
      'titulo': 'Manejo de Deudas',
      'nivel': 2,
      'puntos': 100,
      'duracion': '10 min',
      'descripcion': 'Aprende estrategias para manejar y eliminar deudas de manera inteligente.',
    },
    {
      'id': 5,
      'titulo': 'Fondo de Emergencia',
      'nivel': 3,
      'puntos': 125,
      'duracion': '10 min',
      'descripcion': 'Descubre por qué necesitas un fondo de emergencia y cómo construirlo paso a paso.',
    },
    {
      'id': 6,
      'titulo': 'Introducción a las Inversiones',
      'nivel': 3,
      'puntos': 150,
      'duracion': '12 min',
      'descripcion': 'Aprende los conceptos básicos de inversión y cómo empezar con poco dinero.',
    },
  ];

  void completarLeccion(int leccionId, int puntos) {
    if (!_leccionesCompletadas.contains(leccionId)) {
      _leccionesCompletadas.add(leccionId);
      _puntosActuales += puntos;
      
      while (_puntosActuales >= (_nivelActual * 300)) {
        _puntosActuales -= (_nivelActual * 300);
        _nivelActual++;
      }
      
      notifyListeners();
    }
  }

  bool isCompletada(int id) => _leccionesCompletadas.contains(id);
  
  double get progresoNivel {
    final necesarios = _nivelActual * 300;
    return (_puntosActuales / necesarios) * 100;
  }
}