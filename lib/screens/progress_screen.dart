import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../providers/learning_provider.dart';
import '../providers/finance_provider.dart';
import '../models/achievement_model.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final learning = Provider.of<LearningProvider>(context);
    final finance = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        backgroundColor: const Color(0xFF00BFA5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progreso General
            _buildProgresoGeneral(learning),
            const SizedBox(height: 24),

            // Estadísticas Rápidas
            _buildEstadisticasRapidas(learning, finance),
            const SizedBox(height: 24),

            // Racha Diaria
            _buildRachaDiaria(learning),
            const SizedBox(height: 24),

            // Insignias
            const Text(
              'Insignias',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInsignias(learning),
            const SizedBox(height: 24),

            // Detalles por Categoría
            _buildDetallesCategorias(learning, finance),
          ],
        ),
      ),
    );
  }

  Widget _buildProgresoGeneral(LearningProvider learning) {
    final progreso = learning.progresoGeneral;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Progreso General',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 16,
              percent: progreso / 100,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${progreso.toInt()}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA5),
                    ),
                  ),
                  const Text(
                    'Completado',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              progressColor: const Color(0xFF00BFA5),
              backgroundColor: Colors.grey[300]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.star,
                  '${learning.puntosActuales}',
                  'Puntos',
                  Colors.amber,
                ),
                _buildStatItem(
                  Icons.trending_up,
                  'Nivel ${learning.nivelActual}',
                  'Actual',
                  const Color(0xFF00BFA5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadisticasRapidas(LearningProvider learning, FinanceProvider finance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                Icons.menu_book,
                '${learning.leccionesCompletadasCount}/6',
                'Lecciones',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.receipt_long,
                '${finance.gastos.length}',
                'Gastos',
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                Icons.flag,
                '${finance.metas.length}',
                'Metas',
                Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                Icons.emoji_events,
                '${learning.insigniasDesbloqueadas.length}/9',
                'Insignias',
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRachaDiaria(LearningProvider learning) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Racha Diaria',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${learning.diasConsecutivos} ${learning.diasConsecutivos == 1 ? "día" : "días"} consecutivos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sigue así! Mantén tu racha activa',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsignias(LearningProvider learning) {
    final insignias = learning.todasLasInsignias;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: insignias.length,
      itemBuilder: (context, index) {
        final insignia = insignias[index];
        return _buildInsigniaCard(insignia);
      },
    );
  }

  Widget _buildInsigniaCard(Insignia insignia) {
    return Card(
      elevation: insignia.desbloqueada ? 4 : 1,
      color: insignia.desbloqueada ? Colors.white : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: insignia.desbloqueada
                    ? insignia.color.withOpacity(0.2)
                    : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                insignia.icono,
                size: 32,
                color: insignia.desbloqueada ? insignia.color : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              insignia.nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: insignia.desbloqueada ? Colors.black87 : Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetallesCategorias(LearningProvider learning, FinanceProvider finance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalles',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Progreso de Nivel
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progreso de Nivel',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Nivel ${learning.nivelActual}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: learning.progresoNivel / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BFA5)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${learning.puntosActuales} / ${learning.nivelActual * 300} puntos',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Salud Financiera
        if (learning.saludFinanciera > 0)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Salud Financiera',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: learning.saludFinanciera / 100,
                            minHeight: 12,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FinancialHealthAssessment.getHealthColor(learning.saludFinanciera),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${learning.saludFinanciera}/100',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: FinancialHealthAssessment.getHealthColor(learning.saludFinanciera),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    FinancialHealthAssessment.getHealthLevel(learning.saludFinanciera),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: FinancialHealthAssessment.getHealthColor(learning.saludFinanciera),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
