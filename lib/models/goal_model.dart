class Goal {
  final int? id;
  final int usuarioId;
  final String nombre;
  final double montoObjetivo;
  final double montoActual;
  final DateTime? fechaObjetivo;
  final bool completada;

  Goal({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.montoObjetivo,
    this.montoActual = 0,
    this.fechaObjetivo,
    this.completada = false,
  });

  double get progreso => montoObjetivo > 0 ? (montoActual / montoObjetivo) * 100 : 0;
}