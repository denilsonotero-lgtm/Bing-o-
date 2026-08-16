import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> _cardNumbers = [];
  final Set<int> _markedNumbers = {}; // Armazena os números marcados pelo jogador

  List<int> _generateCard() {
    final List<int> allNumbers = List.generate(75, (i) => i + 1);
    allNumbers.shuffle(Random());
    final card = allNumbers.take(24).toList();
    card.sort();
    return card;
  }

  void _generateNewCard() {
    setState(() {
      _cardNumbers = _generateCard();
      _markedNumbers.clear(); // Limpa as marcações ao gerar nova cartela
    });
  }

  void _toggleMark(int number) {
    setState(() {
      if (_markedNumbers.contains(number)) {
        _markedNumbers.remove(number);
      } else {
        _markedNumbers.add(number);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _generateNewCard();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bingão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Bem-vindo, Jogador!', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  // O espaço central é sempre "marcado"
                  if (index == 12) {
                    return Container(
                      decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Text('FREE', style: TextStyle(fontWeight: FontWeight.bold))),
                    );
                  }

                  final numberIndex = index > 12 ? index - 1 : index;
                  final number = _cardNumbers[numberIndex];
                  final isMarked = _markedNumbers.contains(number);

                  return GestureDetector(
                    onTap: () => _toggleMark(number),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMarked ? Colors.deepPurple : Colors.deepPurple.shade50,
                        border: Border.all(color: Colors.deepPurple, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isMarked ? Colors.white : Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _generateNewCard,
              icon: const Icon(Icons.refresh),
              label: const Text('Gerar Nova Cartela'),
            ),
          ],
        ),
      ),
    );
  }
}
