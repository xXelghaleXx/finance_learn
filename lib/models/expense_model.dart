class Expense {
  final int? id;
  final int usuarioId;
  final String categoria;
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final bool esRecurrente;

  Expense({
    this.id,
    required this.usuarioId,
    required this.categoria,
    required this.monto,
    required this.descripcion,
    required this.fecha,
    this.esRecurrente = false,
  });
}