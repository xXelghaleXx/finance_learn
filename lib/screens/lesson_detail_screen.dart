import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/lesson_model.dart';
import '../providers/learning_provider.dart';
import '../providers/auth_provider.dart';

class LessonDetailScreen extends StatefulWidget {
  final Leccion leccion;

  const LessonDetailScreen({super.key, required this.leccion});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  bool _showQuiz = false;
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _correctAnswers = 0;
  bool _quizCompleted = false;

  @override
  Widget build(BuildContext context) {
    final learning = Provider.of<LearningProvider>(context, listen: false);
    final isCompleted = learning.isCompletada(widget.leccion.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.leccion.titulo),
        actions: [
          if (isCompleted)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Chip(
                avatar: Icon(Icons.check, color: Colors.white, size: 16),
                label: Text('Completada', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
      body: _showQuiz ? _buildQuiz() : _buildLessonContent(),
    );
  }

  Widget _buildLessonContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(widget.leccion.duracion, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 24),
                        Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text('${widget.leccion.puntos} puntos', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                MarkdownBody(
                  data: widget.leccion.contenido,
                  styleSheet: MarkdownStyleSheet(
                    h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    p: const TextStyle(fontSize: 16, height: 1.6),
                    listBullet: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
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
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showQuiz = true;
                  _currentQuestionIndex = 0;
                  _selectedAnswer = null;
                  _showExplanation = false;
                  _correctAnswers = 0;
                  _quizCompleted = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Tomar Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    if (_quizCompleted) {
      return _buildQuizResults();
    }

    final question = widget.leccion.quiz[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.leccion.quiz.length;

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BFA5)),
          minHeight: 8,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pregunta ${_currentQuestionIndex + 1} de ${widget.leccion.quiz.length}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      question.pregunta,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(question.opciones.length, (index) {
                  final isSelected = _selectedAnswer == index;
                  final isCorrect = index == question.respuestaCorrecta;

                  Color? backgroundColor;
                  Color? borderColor;

                  if (_showExplanation) {
                    if (isCorrect) {
                      backgroundColor = Colors.green.withOpacity(0.1);
                      borderColor = Colors.green;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red.withOpacity(0.1);
                      borderColor = Colors.red;
                    }
                  } else if (isSelected) {
                    backgroundColor = const Color(0xFF00BFA5).withOpacity(0.1);
                    borderColor = const Color(0xFF00BFA5);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: _showExplanation ? null : () {
                        setState(() {
                          _selectedAnswer = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor ?? Colors.grey[50],
                          border: Border.all(
                            color: borderColor ?? Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? (borderColor ?? const Color(0xFF00BFA5)) : Colors.transparent,
                                border: Border.all(
                                  color: borderColor ?? Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.opciones[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            if (_showExplanation && isCorrect)
                              const Icon(Icons.check_circle, color: Colors.green),
                            if (_showExplanation && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                if (_showExplanation) ...[
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Explicación',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            question.explicacion,
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
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
            child: !_showExplanation
                ? ElevatedButton(
                    onPressed: _selectedAnswer == null ? null : () {
                      setState(() {
                        _showExplanation = true;
                        if (_selectedAnswer == question.respuestaCorrecta) {
                          _correctAnswers++;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Confirmar Respuesta', style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (_currentQuestionIndex < widget.leccion.quiz.length - 1) {
                        setState(() {
                          _currentQuestionIndex++;
                          _selectedAnswer = null;
                          _showExplanation = false;
                        });
                      } else {
                        setState(() {
                          _quizCompleted = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BFA5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      _currentQuestionIndex < widget.leccion.quiz.length - 1 ? 'Siguiente Pregunta' : 'Ver Resultados',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResults() {
    final percentage = (_correctAnswers / widget.leccion.quiz.length) * 100;
    final passed = percentage >= 70;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final learning = Provider.of<LearningProvider>(context, listen: false);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.refresh,
              size: 100,
              color: passed ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? 'Felicitaciones!' : 'Sigue Practicando',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Obtuviste $_correctAnswers de ${widget.leccion.quiz.length} correctas',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 32),
            if (passed) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            '+${widget.leccion.puntos} puntos',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Has completado esta lección con éxito!'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final quizScore = percentage.toInt();
                  learning.completarLeccion(widget.leccion.id, widget.leccion.puntos, quizScore);
                  auth.updatePuntos(widget.leccion.puntos);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lección completada! +${widget.leccion.puntos} puntos'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BFA5),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('Completar Lección', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ] else ...[
              const Text(
                'Necesitas al menos 70% para completar la lección',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showQuiz = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('Revisar Contenido', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex = 0;
                    _selectedAnswer = null;
                    _showExplanation = false;
                    _correctAnswers = 0;
                    _quizCompleted = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('Reintentar Quiz', style: TextStyle(fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
