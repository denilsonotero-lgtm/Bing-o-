import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Gerenciamento de Múltiplas Cartelas (11 cartelas)
  final List<List<int>> _allCards = [];
  final List<Set<int>> _markedNumbersPerCard = [];
  final List<String> _cardSerialNumbers = [];
  int _currentCardIndex = 0;

  // Sistema de Economia e Partida
  int _userCredits = 150;
  int _roundNumber = 104;

  // Lógica do Sorteio
  final List<int> _drawnNumbers = [];
  int? _currentDrawnNumber;
  bool _isGloboSpinning = false;

  // Preferências e Interface
  bool _autoMark = false;
  Color _selectedColor = Colors.deepPurple;
  bool _showFullBoard = false;
  bool _viewGridMode = false;
  bool _isDarkMode = false;
  bool _soundEffects = true;
  bool _voiceNarrator = true;

  // Recursos Visuais e Áudio
  late AnimationController _globoController;
  final FlutterTts _flutterTts = FlutterTts();

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
    _initTTS();
    _globoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _generateMultipleCards(11);
  }

  @override
  void dispose() {
    _globoController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _initTTS() async {
    await _flutterTts.setLanguage("pt-BR");
    await _flutterTts.setSpeechRate(0.5);
  }

  String _generateSerialNumber(int index) {
    final random = Random().nextInt(89999) + 10000;
    return '#BG-${index + 1}0$random';
  }

  List<int> _generateSingleCard() {
    final List<int> allNumbers = List.generate(75, (i) => i + 1);
    allNumbers.shuffle(Random());
    final card = allNumbers.take(24).toList();
    card.sort();
    return card;
  }

  void _generateMultipleCards(int count) {
    setState(() {
      _allCards.clear();
      _markedNumbersPerCard.clear();
      _cardSerialNumbers.clear();
      _drawnNumbers.clear();
      _currentDrawnNumber = null;
      _currentCardIndex = 0;

      for (int i = 0; i < count; i++) {
        _allCards.add(_generateSingleCard());
        _markedNumbersPerCard.add({});
        _cardSerialNumbers.add(_generateSerialNumber(i));
      }
    });
  }

  void _drawNextNumberSimulated() async {
    if (_drawnNumbers.length >= 75 || _isGloboSpinning) return;

    setState(() => _isGloboSpinning = true);
    _globoController.repeat();

    await Future.delayed(const Duration(milliseconds: 1200));

    final remaining = List.generate(75, (i) => i + 1)
        .where((n) => !_drawnNumbers.contains(n))
        .toList();
    remaining.shuffle(Random());
    final nextNumber = remaining.first;

    _globoController.stop();

    setState(() {
      _isGloboSpinning = false;
      _currentDrawnNumber = nextNumber;
      _drawnNumbers.add(nextNumber);

      if (_autoMark) {
        for (int i = 0; i < _allCards.length; i++) {
          if (_allCards[i].contains(nextNumber)) {
            _markedNumbersPerCard[i].add(nextNumber);
          }
        }
      }
      _checkWinCondition();
    });

    if (_voiceNarrator) {
      await _flutterTts.speak('Número $nextNumber');
    }
  }

  void _toggleMarkUser(int cardIndex, int number) {
    if (!_drawnNumbers.contains(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta pedra ainda não foi sorteada!'),
          duration: Duration(milliseconds: 800),
        ),
      );
      return;
    }

    setState(() {
      final markedSet = _markedNumbersPerCard[cardIndex];
      if (markedSet.contains(number)) {
        markedSet.remove(number);
      } else {
        markedSet.add(number);
      }
      _checkWinCondition();
    });
  }

  List<int> _getRankedCardIndices() {
    List<int> indices = List.generate(_allCards.length, (i) => i);
    indices.sort((a, b) {
      int hitsA = _allCards[a].where((n) => _drawnNumbers.contains(n)).length;
      int hitsB = _allCards[b].where((n) => _drawnNumbers.contains(n)).length;
      return hitsB.compareTo(hitsA);
    });
    return indices;
  }

  void _checkWinCondition() {
    for (int i = 0; i < _allCards.length; i++) {
      final hits = _allCards[i].where((n) => _drawnNumbers.contains(n)).length;
      if (hits == 24) {
        _showBingoDialog(_cardSerialNumbers[i]);
        break;
      }
    }
  }

  void _showBingoDialog(String serial) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.purple.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: const Text(
                    '🎉 B I N G O ! 🎉',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.orange, offset: Offset(0, 4))
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            const Icon(Icons.stars, size: 70, color: Colors.amber),
            const SizedBox(height: 15),
            Text(
              'CARTELA PREMIADA!\nTicket: $serial',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                setState(() => _userCredits += 50);
                Navigator.pop(context);
              },
              child: const Text('VALIDAR PRÊMIO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  void _openSettingsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Configurações & Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Modo Escuro (Dark Theme)'),
                    value: _isDarkMode,
                    onChanged: (val) {
                      setState(() => _isDarkMode = val);
                      setModalState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Efeitos Sonoros'),
                    value: _soundEffects,
                    onChanged: (val) {
                      setState(() => _soundEffects = val);
                      setModalState(() {});
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Narrador de Voz'),
                    value: _voiceNarrator,
                    onChanged: (val) {
                      setState(() => _voiceNarrator = val);
                      setModalState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentDrawn = _drawnNumbers.length > 1
        ? _drawnNumbers.sublist(0, _drawnNumbers.length - 1).reversed.toList()
        : <int>[];
    
    final rankedIndices = _getRankedCardIndices();
    final bgColor = _isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50;
    final textColor = _isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Colors.grey.shade900 : Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.amber.shade800, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, size: 16, color: Colors.white),
                  const SizedBox(width: 4),
                  Text('$_userCredits', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('Rodada #$_roundNumber', style: const TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_viewGridMode ? Icons.view_carousel : Icons.grid_view),
            onPressed: () => setState(() => _viewGridMode = !_viewGridMode),
          ),
          IconButton(
            icon: Icon(_showFullBoard ? Icons.grid_off : Icons.grid_on),
            onPressed: () => setState(() => _showFullBoard = !_showFullBoard),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettingsModal,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  RotationTransition(
                    turns: _globoController,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 2.5),
                        gradient: SweepGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade800, Colors.grey.shade400],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.refresh, color: Colors.amber, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentDrawnNumber != null ? Colors.amber : Colors.grey.shade800,
                      boxShadow: _currentDrawnNumber != null
                          ? [BoxShadow(color: Colors.amber.withOpacity(0.8), blurRadius: 10, spreadRadius: 2)]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        _currentDrawnNumber != null ? '$_currentDrawnNumber' : '--',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        itemCount: recentDrawn.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 38,
                            height: 38,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${recentDrawn[index]}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            if (_showFullBoard)
              Container(
                height: 140,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 15,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: 75,
                  itemBuilder: (context, index) {
                    final num = index + 1;
                    final isDrawn = _drawnNumbers.contains(num);

                    return Container(
                      decoration: BoxDecoration(
                        color: isDrawn ? Colors.amber : (_isDarkMode ? Colors.grey.shade800 : Colors.white),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Text(
                          '$num',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: isDrawn ? FontWeight.bold : FontWeight.normal,
                            color: isDrawn ? Colors.black : textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Card(
              elevation: 1,
              color: _isDarkMode ? Colors.grey.shade900 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: _availableColors.map((color) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: _selectedColor == color ? Border.all(color: textColor, width: 2) : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Text('Auto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
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
            Expanded(
              child: _viewGridMode
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _allCards.length,
                      itemBuilder: (context, rankIndex) {
                        final cardIndex = rankedIndices[rankIndex];
                        final card = _allCards[cardIndex];
                        final hits = card.where((n) => _drawnNumbers.contains(n)).length;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentCardIndex = cardIndex;
                              _viewGridMode = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple, width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: _isDarkMode ? Colors.grey.shade900 : Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.deepPurple,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_cardSerialNumbers[cardIndex], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      Text('$hits/24', style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                                    itemCount: 25,
                                    itemBuilder: (context, idx) {
                                      if (idx == 12) return const Center(child: Text('F', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)));
                                      final numIdx = idx > 12 ? idx - 1 : idx;
                                      final number = card[numIdx];
                                      final isMarked = _markedNumbersPerCard[cardIndex].contains(number);
                                      return Center(
                                        child: Text(
                                          '$number',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: isMarked ? Colors.red : textColor,
                                            fontWeight: isMarked ? FontWeight.bold : FontWeight.normal,
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
                      },
                    )
                  : PageView.builder(
                      itemCount: _allCards.length,
                      onPageChanged: (index) => setState(() => _currentCardIndex = index),
                      itemBuilder: (context, cardIndex) {
                        final card = _allCards[cardIndex];
                        final marked = _markedNumbersPerCard[cardIndex];

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.deepPurple, width: 3),
                            borderRadius: BorderRadius.circular(16),
                            color: _isDarkMode ? Colors.grey.shade900 : Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                decoration: const BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'CARTELA ${cardIndex + 1} DE 11',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      _cardSerialNumbers[cardIndex],
                                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
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
                                          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)),
                                          child: const Center(child: Text('FREE', style: TextStyle(fontWeight: FontWeight.bold))),
                                        );
                                      }

                                      final numberIndex = index > 12 ? index - 1 : index;
                                      final number = card[numberIndex];
                                      final isMarked = marked.contains(number);

                                      return GestureDetector(
                                        onTap: () => _toggleMarkUser(cardIndex, number),
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _drawNextNumberSimulated,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Girar Globo & Sortear'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade800, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _generateMultipleCards(11),
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Novas Cartelas',
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
