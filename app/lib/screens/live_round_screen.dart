import 'package:flutter/material.dart';

class LiveRoundScreen extends StatefulWidget {
  const LiveRoundScreen({super.key});

  @override
  State<LiveRoundScreen> createState() => _LiveRoundScreenState();
}

class _LiveRoundScreenState extends State<LiveRoundScreen> {
  // Dados de simulação da rodada ao vivo
  final int _currentBall = 41;
  final List<int> _drawnBalls = [4, 18, 33, 49, 67, 8, 22, 41];

  // Exemplo da melhor cartela do jogador no momento
  final List<List<int>> _bestCard = [
    [4, 18, 33, 49, 67],
    [8, 22, 38, 54, 71],
    [12, 29, 0, 57, 73],
    [2, 16, 41, 62, 69],
    [14, 25, 46, 58, 75],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rodada #001284 • Ao Vivo'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Chip(
              avatar: Icon(Icons.circle, color: Colors.red, size: 12),
              label: Text('AO VIVO', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Painel de Progresso por Modalidade
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROGRESSO DAS MODALIDADES',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    _buildProgressBar('Linha', 1.0, '5/5 🏆'),
                    _buildProgressBar('Coluna', 0.8, '4/5'),
                    _buildProgressBar('Janelão', 0.5, '10/20'),
                    _buildProgressBar('Cartela Cheia', 0.33, '8/24'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Destaque da Bola Atual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('ÚLTIMA BOLA SORTEADA'),
                    const SizedBox(height: 12),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        '$_currentBall',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Total sorteado: ${_drawnBalls.length} / 75'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Melhor Cartela
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SUA MELHOR CARTELA (#00482)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '🟢 8 ACERTOS',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildMiniGrid(_bestCard),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Histórico Geral de Bolas (1 a 75)
            ExpansionTile(
              title: const Text('Painel Geral de Bolas (1 a 75)'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: 75,
                    itemBuilder: (context, index) {
                      final number = index + 1;
                      final isDrawn = _drawnBalls.contains(number);

                      return Container(
                        decoration: BoxDecoration(
                          color: isDrawn ? Colors.deepPurple : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            '$number',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isDrawn ? FontWeight.bold : FontWeight.normal,
                              color: isDrawn ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String title, double progress, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            color: progress == 1.0 ? Colors.green : Colors.deepPurple,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGrid(List<List<int>> grid) {
    return Column(
      children: grid.map((row) {
        return Row(
          children: row.map((num) {
            final isFree = num == 0;
            final isHit = _drawnBalls.contains(num) || isFree;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                height: 32,
                decoration: BoxDecoration(
                  color: isHit ? Colors.green.shade600 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: isFree
                      ? const Icon(Icons.star, size: 14, color: Colors.amber)
                      : Text(
                          '$num',
                          style: TextStyle(
                            fontSize: 12,
                            color: isHit ? Colors.white : Colors.black87,
                            fontWeight: isHit ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
