import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/learning_provider.dart';
import '../../providers/auth_provider.dart';
import '../lesson_detail_screen.dart';

class LearnTab extends StatelessWidget {
  const LearnTab({super.key});

  @override
  Widget build(BuildContext context) {
    final learning = Provider.of<LearningProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aprende'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Chip(
              avatar: Text('${learning.nivelActual}', style: const TextStyle(fontWeight: FontWeight.bold)),
              label: Text('${learning.puntosActuales} pts'),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: learning.lecciones.length,
        itemBuilder: (context, index) {
          final leccion = learning.lecciones[index];
          final completada = learning.isCompletada(leccion.id);
          final bloqueada = leccion.nivel > learning.nivelActual + 1;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: completada ? Colors.green : (bloqueada ? Colors.grey : const Color(0xFF00BFA5)),
                child: Icon(
                  completada ? Icons.check : (bloqueada ? Icons.lock : Icons.play_arrow),
                  color: Colors.white,
                ),
              ),
              title: Text(leccion.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leccion.descripcion),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Nivel ${leccion.nivel}'), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      Chip(label: Text(leccion.duracion), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      Chip(label: Text('${leccion.puntos} pts'), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ],
                  ),
                ],
              ),
              trailing: bloqueada ? null : const Icon(Icons.arrow_forward_ios),
              onTap: bloqueada ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailScreen(leccion: leccion),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}