import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement_model.dart';
import '../providers/learning_provider.dart';

class FinancialHealthAssessmentScreen extends StatefulWidget {
  const FinancialHealthAssessmentScreen({super.key});

  @override
  State<FinancialHealthAssessmentScreen> createState() => _FinancialHealthAssessmentScreenState();
}

class _FinancialHealthAssessmentScreenState extends State<FinancialHealthAssessmentScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, int> _respuestas = {};
  bool _completed = false;
  int _puntajeTotal = 0;

  @override
  Widget build(BuildContext context) {
    if (_completed) {
      return _buildResultados();
    }

    final pregunta = FinancialHealthAssessment.preguntas[_currentQuestionIndex];
    final progreso = (_currentQuestionIndex + 1) / FinancialHealthAssessment.preguntas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de Salud Financiera'),
        backgroundColor: const Color(0xFF00BFA5),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progreso,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BFA5)),
            minHeight: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pregunta ${_currentQuestionIndex + 1} de ${FinancialHealthAssessment.preguntas.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    color: const Color(0xFF00BFA5).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 40,
                            color: const Color(0xFF00BFA5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            pregunta.pregunta,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Selecciona la opción que mejor te describa:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...pregunta.opciones.asMap().entries.map((entry) {
                    final index = entry.key;
                    final opcion = entry.value;
                    final isSelected = _respuestas[_currentQuestionIndex] == index;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _respuestas[_currentQuestionIndex] = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF00BFA5).withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF00BFA5)
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF00BFA5).withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? const Color(0xFF00BFA5)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF00BFA5)
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  opcion.texto,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected ? const Color(0xFF00BFA5) : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Anterior', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _respuestas.containsKey(_currentQuestionIndex)
                          ? () {
                              if (_currentQuestionIndex < FinancialHealthAssessment.preguntas.length - 1) {
                                setState(() {
                                  _currentQuestionIndex++;
                                });
                              } else {
                                _calcularResultado();
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentQuestionIndex < FinancialHealthAssessment.preguntas.length - 1
                            ? 'Siguiente'
                            : 'Ver Resultados',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _calcularResultado() {
    int total = 0;
    _respuestas.forEach((preguntaIndex, opcionIndex) {
      final pregunta = FinancialHealthAssessment.preguntas[preguntaIndex];
      total += pregunta.opciones[opcionIndex].puntos;
    });

    setState(() {
      _puntajeTotal = total;
      _completed = true;
    });

    // Guardar en el provider
    final learning = Provider.of<LearningProvider>(context, listen: false);
    learning.establecerSaludFinanciera(total);
  }

  Widget _buildResultados() {
    final nivel = FinancialHealthAssessment.getHealthLevel(_puntajeTotal);
    final color = FinancialHealthAssessment.getHealthColor(_puntajeTotal);
    final consejo = FinancialHealthAssessment.getHealthAdvice(_puntajeTotal);
    final porcentaje = (_puntajeTotal / 100) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        backgroundColor: const Color(0xFF00BFA5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(
              _getIconForLevel(_puntajeTotal),
              size: 100,
              color: color,
            ),
            const SizedBox(height: 24),
            Text(
              'Tu Salud Financiera',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              nivel,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_puntajeTotal',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        ' / 100',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: porcentaje / 100,
                      minHeight: 20,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          'Recomendaciones',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      consejo,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: const Color(0xFF00BFA5).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 48,
                      color: Color(0xFF00BFA5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Próximos Pasos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Completa las lecciones de finanzas para mejorar tu puntuación y aprender a gestionar mejor tu dinero.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text('Continuar', style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLevel(int puntos) {
    if (puntos >= 80) return Icons.emoji_events;
    if (puntos >= 60) return Icons.thumb_up;
    if (puntos >= 40) return Icons.trending_up;
    if (puntos >= 20) return Icons.warning;
    return Icons.error;
  }
}
