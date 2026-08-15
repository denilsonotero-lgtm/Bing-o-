import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎱 BINGÃO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Bem-vindo ao BINGÃO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Acompanhe suas rodadas e cartelas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 35),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '🎱',
                        style: TextStyle(fontSize: 60),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nenhuma rodada disponível',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Quando houver uma rodada, ela aparecerá aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.confirmation_number),
                label: const Text('Minhas cartelas'),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history),
                label: const Text('Histórico'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
