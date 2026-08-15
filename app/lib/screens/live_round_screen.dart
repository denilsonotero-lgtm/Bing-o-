import 'dart:async';
import 'package:flutter/material.dart';

class LiveRoundScreen extends StatefulWidget {
  const LiveRoundScreen({super.key});

  @override
  State<LiveRoundScreen> createState() =>
      _LiveRoundScreenState();
}

class _LiveRoundScreenState extends State<LiveRoundScreen> {
  Timer? timer;

  final List<int> drawnBalls = [];

  int? currentBall;
  bool drawing = false;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void drawBall() {
    if (drawing) return;

    setState(() {
      drawing = true;
    });

    timer = Timer(const Duration(seconds: 2), () {
      int nextBall;

      do {
        nextBall =
            1 + DateTime.now().millisecond % 75;
      } while (drawnBalls.contains(nextBall));

      setState(() {
        currentBall = nextBall;
        drawnBalls.insert(0, nextBall);
        drawing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rodada ao vivo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            const Text(
              'RODADA #001284',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Participantes: 128',
            ),

            const SizedBox(height: 20),

            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: drawing ? 150 : 180,
              height: drawing ? 150 : 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                ),
              ),
              alignment: Alignment.center,
              child: drawing
                  ? const CircularProgressIndicator()
                  : Text(
                      currentBall == null
                          ? '—'
                          : '$currentBall',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            Text(
              drawing
                  ? 'SORTEANDO...'
                  : currentBall == null
                      ? 'Aguardando sorteio'
                      : 'BOLA SORTEADA',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: drawing ? null : drawBall,
                  icon: const Icon(Icons.casino),
                  label: const Text('SORTEAR BOLA'),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Histórico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: drawnBalls.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma bola sorteada ainda.',
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      itemCount: drawnBalls.length,
                      itemBuilder: (context, index) {
                        final ball =
                            drawnBalls[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('$ball'),
                            ),
                            title: Text(
                              'Bola $ball',
                            ),
                            subtitle: Text(
                              'Sorteio ${drawnBalls.length - index}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
