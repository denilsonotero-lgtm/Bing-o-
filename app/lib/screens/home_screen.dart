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
  final List<int> _drawnNumbers = []; // Histórico das pedras sorteadas
  bool _autoMark = false;
  Color _selectedColor = Colors.deepPurple;
  bool _showFullBoard = false; // Controla se o painel 1-75 está visível

  final List<Color> _availableColors = [
    Colors.deepPurple,
    Colors.red,
    Colors.amber.shade700,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    _generateNewCard();
  }

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
      _drawnNumbers.clear();
    });
  }

  // Função para simular o sorteio de uma nova bola (para testes)
  void _drawNextNumber() {
    if (_drawnNumbers.length >= 75) return;
    
    final remainingNumbers = List.generate(75, (i) => i + 1)
        .where((n) => !_drawnNumbers.contains(n))
        .toList();
    remainingNumbers.shuffle(Random());
    
    final nextNumber = remainingNumbers.first;

    setState(() {
      _drawnNumbers.add(nextNumber);

      // Se a marcação automática estiver LIGADA, ele marca na cartela do usuário sozinho
      if (_autoMark && _cardNumbers.contains(nextNumber)) {
        _markedNumbers.add(nextNumber);
      }
      
      _checkWinCondition();
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

  void _checkWinCondition() {
    // Validação automática sem depender da marcação manual
    final matched = _cardNumbers.where((n) => _drawnNumbers.contains(n)).length;
    if (matched == 24) {
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
          child: Text('🎉 BINGO! 🎉', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            SizedBox(height: 10),
            Text('Parabéns! Sua cartela foi premiada!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
  Widget build(BuildContext context) {
    // Últimas bolas em ordem inversa (da mais recente para a mais antiga - Direita para Esquerda)
    final recentDrawn = _drawnNumbers.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bingão'),
        actions: [
          IconButton(
            icon: Icon(_showFullBoard ? Icons.grid_off : Icons.grid_on),
            tooltip: 'Tabela 1-75',
            onPressed: () => setState(() => _showFullBoard = !_showFullBoard),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            // 1. BARRA HORIZONTAL DE ÚLTIMAS BOLAS (Da direita para a esquerda)
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: recentDrawn.isEmpty
                  ? const Center(child: Text('Aguardando sorteio...', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // Faz a lista ir da direita para a esquerda
                      itemCount: recentDrawn.length,
                      itemBuilder: (context, index) {
                        final number = recentDrawn[index];
                        final isLatest = index == 0; // A bola mais recente

                        return Container(
                          width: isLatest ? 50 : 40,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isLatest ? Colors.amber : Colors.deepPurple,
                            shape: BoxShape.circle,
                            boxShadow: isLatest
                                ? [BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 6, spreadRadius: 2)]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '$number',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isLatest ? 18 : 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),

            // 2. PAINEL DE 1 A 75 (Pode ser aberto ou fechado pelo ícone da AppBar)
            if (_showFullBoard)
              Container(
                height: 180,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15, // 15 colunas para caber os 75 números bem compactos
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 75,
                  itemBuilder: (context, index) {
                    final num = index + 1;
                    final isDrawn = _drawnNumbers.contains(num);

                    return Container(
                      decoration: BoxDecoration(
                        color: isDrawn ? Colors.amber : Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.grey.shade300, width: 0.5),
                      ),
                      child: Center(
                        child: Text(
                          '$num',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isDrawn ? FontWeight.bold : FontWeight.normal,
                            color: isDrawn ? Colors.black : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // 3. BARRA DE OPÇÕES (Cores + Modo Auto)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: _availableColors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        const Text('Auto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Switch(
                          value: _autoMark,
                          activeColor: _selectedColor,
                          onChanged: (val) => setState(() => _autoMark = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),

            // 4. GRADE DA CARTELA
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
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
                        child: Text('FREE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
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
                        color: isMarked ? _selectedColor : _selectedColor.withOpacity(0.08),
                        border: Border.all(color: _selectedColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: 16,
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

            // BOTOES DE TESTE/CONTROLE
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _drawNextNumber,
                    icon: const Icon(Icons.casino),
                    label: const Text('Sortear Pedra'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _generateNewCard,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Nova Cartela',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
