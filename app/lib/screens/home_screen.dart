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
  bool _isLoading = false;

  // Gerador de cartela com 24 números aleatórios entre 1 e 75
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
        title: const Text('Bingão - Minha Cartela'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Bem-vindo, ${user?.email ?? "Jogador"}!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Grid da Cartela de Bingo
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 25, // 24 números + 1 espaço BINGO livre no meio
                itemBuilder: (context, index) {
                  if (index == 12) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'FREE',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    );
                  }

                  final numberIndex = index > 12 ? index - 1 : index;
                  final number = _cardNumbers.isNotEmpty ? _cardNumbers[numberIndex] : 0;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
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
