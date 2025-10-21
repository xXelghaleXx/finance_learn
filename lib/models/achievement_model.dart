import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;
  final int puntosRequeridos;
  final String categoria;

  Achievement({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
    required this.puntosRequeridos,
    required this.categoria,
  });
}

class Insignia {
  final String id;
  final String nombre;
  final String descripcion;
  final IconData icono;
  final Color color;
  final bool desbloqueada;
  final DateTime? fechaDesbloqueo;

  Insignia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.color,
    this.desbloqueada = false,
    this.fechaDesbloqueo,
  });
}

class AchievementsData {
  static final List<Insignia> insignias = [
    Insignia(
      id: 'primer_paso',
      nombre: 'Primer Paso',
      descripcion: 'Completa tu primera lección',
      icono: Icons.school,
      color: Colors.blue,
    ),
    Insignia(
      id: 'aprendiz',
      nombre: 'Aprendiz',
      descripcion: 'Completa 3 lecciones',
      icono: Icons.emoji_events,
      color: Colors.green,
    ),
    Insignia(
      id: 'maestro_finanzas',
      nombre: 'Maestro de Finanzas',
      descripcion: 'Completa todas las lecciones',
      icono: Icons.workspace_premium,
      color: Colors.amber,
    ),
    Insignia(
      id: 'organizador',
      nombre: 'Organizador',
      descripcion: 'Registra 10 gastos',
      icono: Icons.checklist,
      color: Colors.purple,
    ),
    Insignia(
      id: 'ahorrador',
      nombre: 'Ahorrador',
      descripcion: 'Crea tu primera meta de ahorro',
      icono: Icons.savings,
      color: Colors.teal,
    ),
    Insignia(
      id: 'planificador',
      nombre: 'Planificador',
      descripcion: 'Completa una meta de ahorro',
      icono: Icons.task_alt,
      color: Colors.orange,
    ),
    Insignia(
      id: 'racha_7',
      nombre: 'Racha de Fuego',
      descripcion: 'Ingresa 7 días consecutivos',
      icono: Icons.local_fire_department,
      color: Colors.red,
    ),
    Insignia(
      id: 'nivel_5',
      nombre: 'Experto',
      descripcion: 'Alcanza el nivel 5',
      icono: Icons.military_tech,
      color: Colors.indigo,
    ),
    Insignia(
      id: 'quiz_perfecto',
      nombre: 'Perfección',
      descripcion: 'Obtén 100% en un quiz',
      icono: Icons.star,
      color: Colors.yellow,
    ),
  ];
}

class UserProgress {
  final int totalPuntos;
  final int leccionesCompletadas;
  final int gastosRegistrados;
  final int metasCreadas;
  final int metasCompletadas;
  final int diasConsecutivos;
  final DateTime ultimoAcceso;
  final int nivelActual;
  final List<String> insigniasDesbloqueadas;
  final Map<String, int> quizScores;
  final int salud_financiera; // Puntaje de 0-100

  UserProgress({
    this.totalPuntos = 0,
    this.leccionesCompletadas = 0,
    this.gastosRegistrados = 0,
    this.metasCreadas = 0,
    this.metasCompletadas = 0,
    this.diasConsecutivos = 0,
    required this.ultimoAcceso,
    this.nivelActual = 1,
    this.insigniasDesbloqueadas = const [],
    this.quizScores = const {},
    this.salud_financiera = 0,
  });

  // Calcular progreso general (0-100)
  double get progresoGeneral {
    final maxLecciones = 6;
    final pesoLecciones = (leccionesCompletadas / maxLecciones) * 30;
    final pesoGastos = (gastosRegistrados >= 10 ? 20 : (gastosRegistrados / 10) * 20);
    final pesoMetas = (metasCompletadas >= 3 ? 25 : (metasCompletadas / 3) * 25);
    final pesoInsignias = (insigniasDesbloqueadas.length / 9) * 15;
    final pesoNivel = (nivelActual >= 5 ? 10 : (nivelActual / 5) * 10);

    return pesoLecciones + pesoGastos + pesoMetas + pesoInsignias + pesoNivel;
  }
}

class FinancialHealthQuestion {
  final String pregunta;
  final List<FinancialHealthOption> opciones;

  FinancialHealthQuestion({
    required this.pregunta,
    required this.opciones,
  });
}

class FinancialHealthOption {
  final String texto;
  final int puntos;

  FinancialHealthOption({
    required this.texto,
    required this.puntos,
  });
}

class FinancialHealthAssessment {
  static final List<FinancialHealthQuestion> preguntas = [
    FinancialHealthQuestion(
      pregunta: '¿Tienes un presupuesto mensual?',
      opciones: [
        FinancialHealthOption(texto: 'Sí, lo sigo estrictamente', puntos: 20),
        FinancialHealthOption(texto: 'Sí, pero no siempre lo sigo', puntos: 15),
        FinancialHealthOption(texto: 'Tengo uno básico', puntos: 10),
        FinancialHealthOption(texto: 'No tengo presupuesto', puntos: 0),
      ],
    ),
    FinancialHealthQuestion(
      pregunta: '¿Tienes un fondo de emergencia?',
      opciones: [
        FinancialHealthOption(texto: 'Sí, cubre 6+ meses', puntos: 25),
        FinancialHealthOption(texto: 'Sí, cubre 3-6 meses', puntos: 20),
        FinancialHealthOption(texto: 'Sí, cubre 1-3 meses', puntos: 15),
        FinancialHealthOption(texto: 'Tengo algo ahorrado', puntos: 10),
        FinancialHealthOption(texto: 'No tengo fondo de emergencia', puntos: 0),
      ],
    ),
    FinancialHealthQuestion(
      pregunta: '¿Ahorras regularmente?',
      opciones: [
        FinancialHealthOption(texto: 'Sí, 20% o más de mis ingresos', puntos: 20),
        FinancialHealthOption(texto: 'Sí, 10-20% de mis ingresos', puntos: 15),
        FinancialHealthOption(texto: 'Sí, menos del 10%', puntos: 10),
        FinancialHealthOption(texto: 'Solo cuando me sobra', puntos: 5),
        FinancialHealthOption(texto: 'No ahorro', puntos: 0),
      ],
    ),
    FinancialHealthQuestion(
      pregunta: '¿Cómo manejas tus deudas?',
      opciones: [
        FinancialHealthOption(texto: 'No tengo deudas', puntos: 20),
        FinancialHealthOption(texto: 'Pago más del mínimo siempre', puntos: 15),
        FinancialHealthOption(texto: 'Pago el mínimo a tiempo', puntos: 10),
        FinancialHealthOption(texto: 'A veces me atraso', puntos: 5),
        FinancialHealthOption(texto: 'Tengo muchas deudas atrasadas', puntos: 0),
      ],
    ),
    FinancialHealthQuestion(
      pregunta: '¿Registras tus gastos?',
      opciones: [
        FinancialHealthOption(texto: 'Sí, todos mis gastos', puntos: 15),
        FinancialHealthOption(texto: 'Solo los gastos grandes', puntos: 10),
        FinancialHealthOption(texto: 'Ocasionalmente', puntos: 5),
        FinancialHealthOption(texto: 'No los registro', puntos: 0),
      ],
    ),
  ];

  static String getHealthLevel(int puntos) {
    if (puntos >= 80) return 'Excelente';
    if (puntos >= 60) return 'Buena';
    if (puntos >= 40) return 'Regular';
    if (puntos >= 20) return 'Necesita Mejora';
    return 'Crítica';
  }

  static Color getHealthColor(int puntos) {
    if (puntos >= 80) return Colors.green;
    if (puntos >= 60) return Colors.lightGreen;
    if (puntos >= 40) return Colors.orange;
    if (puntos >= 20) return Colors.deepOrange;
    return Colors.red;
  }

  static String getHealthAdvice(int puntos) {
    if (puntos >= 80) {
      return 'Excelente trabajo! Mantén tus buenos hábitos financieros y considera inversiones más avanzadas.';
    }
    if (puntos >= 60) {
      return 'Vas por buen camino. Enfócate en fortalecer tu fondo de emergencia y aumentar tu tasa de ahorro.';
    }
    if (puntos >= 40) {
      return 'Hay espacio para mejorar. Empieza creando un presupuesto y registrando todos tus gastos.';
    }
    if (puntos >= 20) {
      return 'Es momento de tomar control. Prioriza crear un fondo de emergencia pequeño y pagar deudas.';
    }
    return 'Situación crítica. Busca asesoría financiera y comienza con las lecciones básicas de esta app.';
  }
}
