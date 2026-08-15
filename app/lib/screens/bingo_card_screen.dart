import 'package:flutter/material.dart';

class BingoCardScreen extends StatelessWidget {
  const BingoCardScreen({super.key});

  static const List<List<int>> card = [
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
        title: const Text('Cartela #00482'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            const Text(
              '🎯 7 acertos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'BINGÃO • Rodada #001284',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            // Cabeçalho B-I-N-G-O
            Row(
              children: const [
                _HeaderLetter('B'),
                _HeaderLetter('I'),
                _HeaderLetter('N'),
                _HeaderLetter('G'),
                _HeaderLetter('O'),
              ],
            ),

            // Cartela
            Expanded(
              child: Column(
                children: List.generate(
                  5,
                  (row) {
                    return Expanded(
                      child: Row(
                        children: List.generate(
                          5,
                          (column) {
                            final number = card[row][column];

                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(3),
                                child: _NumberCell(
                                  number: number,
                                  marked: number == 41 ||
                                      number == 18 ||
                                      number == 22 ||
                                      number == 38 ||
                                      number == 49 ||
                                      number == 57 ||
                                      number == 0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Progresso',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ProgressRow(
                        title: 'Linha',
                        value: '4/5',
                      ),
                      _ProgressRow(
                        title: 'Coluna',
                        value: '3/5',
                      ),
                      _ProgressRow(
                        title: 'Janelão',
                        value: '12/20',
                      ),
                      _ProgressRow(
                        title: 'Cheia',
                        value: '17/24',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _HeaderLetter extends StatelessWidget {
  final String letter;

  const _HeaderLetter(this.letter);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _NumberCell extends StatelessWidget {
  final int number;
  final bool marked;

  const _NumberCell({
    required this.number,
    required this.marked,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = number == 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: marked
              ? Colors.green.withOpacity(0.35)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          isFree ? '★' : '$number',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: marked
                ? Colors.green.shade800
                : null,
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String title;
  final String value;

  const _ProgressRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
