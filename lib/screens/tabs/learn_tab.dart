import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/learning_provider.dart';
import '../../providers/auth_provider.dart';

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
        itemCount: LearningProvider.lecciones.length,
        itemBuilder: (context, index) {
          final leccion = LearningProvider.lecciones[index];
          final completada = learning.isCompletada(leccion['id']);
          final bloqueada = leccion['nivel'] > learning.nivelActual + 1;

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
              title: Text(leccion['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leccion['descripcion']),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Nivel ${leccion['nivel']}'), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      Chip(label: Text(leccion['duracion']), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      Chip(label: Text('${leccion['puntos']} pts'), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    ],
                  ),
                ],
              ),
              trailing: bloqueada ? null : const Icon(Icons.arrow_forward_ios),
              onTap: bloqueada ? null : () => _showLeccionDialog(context, leccion, learning, auth),
            ),
          );
        },
      ),
    );
  }

  void _showLeccionDialog(BuildContext context, Map<String, dynamic> leccion, LearningProvider learning, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(leccion['titulo']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(leccion['descripcion']),
              const SizedBox(height: 20),
              const Text('Contenido de la lección:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'En esta lección aprenderás conceptos fundamentales que te ayudarán a tomar mejores decisiones financieras. Incluye ejemplos prácticos y ejercicios interactivos.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          ElevatedButton(
            onPressed: () {
              learning.completarLeccion(leccion['id'], leccion['puntos']);
              auth.updatePuntos(leccion['puntos']);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lección completada! +${leccion['puntos']} puntos'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Completar'),
          ),
        ],
      ),
    );
  }
}