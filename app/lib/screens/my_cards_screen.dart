import 'package:flutter/material.dart';
import 'bingo_card_screen.dart';

class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  final PageController pageController = PageController();

  int currentCard = 0;

  final List<int> cardNumbers = [
    7,
    12,
    5,
    9,
    3,
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas cartelas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          Text(
            'Cartela ${currentCard + 1} de ${cardNumbers.length}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Deslize para trocar de cartela',
          ),

          const SizedBox(height: 12),

          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: cardNumbers.length,
              onPageChanged: (index) {
                setState(() {
                  currentCard = index;
                });
              },
              itemBuilder: (context, index) {
                return _CardPreview(
                  cardNumber: index + 1,
                  hits: cardNumbers[index],
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const BingoCardScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_full),
                label: const Text('ABRIR CARTELA'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPreview extends StatelessWidget {
  final int cardNumber;
  final int hits;

  const _CardPreview({
    required this.cardNumber,
    required this.hits,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cartela #$cardNumber',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$hits acertos',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: _MiniCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        final isMarked =
            index == 2 ||
            index == 6 ||
            index == 10 ||
            index == 15 ||
            index == 20;

        final isFree = index == 12;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(),
          ),
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isMarked
                  ? Colors.green.withOpacity(0.35)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              isFree ? '★' : '${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
