import 'package:flutter/material.dart';

class BingoRoomScreen extends StatelessWidget {
  const BingoRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎱 BINGÃO AO VIVO'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Bola atual
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'BOLA ATUAL',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium,
                      ),
                      const SizedBox(height: 12),

                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '--',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Aguardando próxima bola...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Histórico
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📜 Histórico das bolas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          _Ball(number: 41),
                          _Ball(number: 23),
                          _Ball(number: 7),
                          _Ball(number: 58),
                          _Ball(number: 32),
                          _Ball(number: 14),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Ver todas as bolas',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Progresso
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎯 Meu progresso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _ProgressItem(
                        title: 'Linha',
                        value: 0.80,
                      ),
                      _ProgressItem(
                        title: 'Coluna',
                        value: 0.60,
                      ),
                      _ProgressItem(
                        title: 'Janelão',
                        value: 0.50,
                      ),
                      _ProgressItem(
                        title: 'Cartela cheia',
                        value: 0.65,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Melhor cartela
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Text('🎟️'),
                  ),
                  title: const Text(
                    'Minha melhor cartela',
                  ),
                  subtitle: const Text(
                    'Cartela #00482 • 7 acertos',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ball extends StatelessWidget {
  final int number;

  const _Ball({
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(
        '$number',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String title;
  final double value;

  const _ProgressItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: value,
          ),
        ],
      ),
    );
  }
}
