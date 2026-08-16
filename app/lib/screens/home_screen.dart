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
  final Set<int> _markedNumbers = {};
  bool _autoMark = false; // Se a marcação automática está ligada
  Color _selectedColor = Colors.deepPurple; // Cor padrão da marcação
  bool _isWinner = false; // Estado do prêmio

  // Cores disponíveis para a marcação
  final List<Color> _availableColors = [
    Colors.deepPurple,
    Colors.red,
    Colors.amber.shade700,
    Colors.green,
    Colors.blue,
  ];

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
      _markedNumbers.clear();
      _isWinner = false;
    });
  }

  void _toggleMark(int number) {
    setState(() {
      if (_markedNumbers.contains(number)) {
        _markedNumbers.remove(number);
      } else {
        _markedNumbers.add(number);
      }
      _checkWinCondition();
    });
  }

  // Validação em segundo plano (O sistema sempre conta para você)
  void _checkWinCondition() {
    // Exemplo de regra: se o jogador marcou 5 ou mais pedras (ou via auto-mark)
    // Aqui você conectará com os números sorteados da sala do Supabase
    if (_markedNumbers.length >= 24 && !_isWinner) {
      setState(() => _isWinner = true);
      _showBingoDialog();
    }
  }

  void _showBingoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.amber.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text(
            '🎉 BINGO! 🎉',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            SizedBox(height: 10),
            Text(
              'Parabéns! Sua cartela foi premiada!',
              textAlign: TextAlign.Center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () => Navigator.pop(context),
              child: const Text('RECEBER PRÊMIO', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _generateNewCard();
  }

  @override
  Widget build(BuildContext context) {
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
            // Painel de Configurações de Marcação (Cores + Automático)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Seleção de Cores
                    Row(
                      children: _availableColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    // Switch de Marcação Automática
                    Row(
                      children: [
                        const Text('Auto', style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: _autoMark,
                          activeColor: _selectedColor,
                          onChanged: (val) {
                            setState(() {
                              _autoMark = val;
                              // Se ligar a auto-marcação, ele pode marcar automaticamente as pedras
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Grade da Cartela
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  if (index == 12) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('FREE', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  }

                  final numberIndex = index > 12 ? index - 1 : index;
                  final number = _cardNumbers[numberIndex];
                  final isMarked = _markedNumbers.contains(number);

                  return GestureDetector(
                    onTap: () => _toggleMark(number),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isMarked ? _selectedColor : _selectedColor.withOpacity(0.1),
                        border: Border.all(color: _selectedColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isMarked ? Colors.white : _selectedColor,
                          ),
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
