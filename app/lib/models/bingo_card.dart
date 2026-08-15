class BingoCard {
  final String id;
  final String playerId;
  final String roundId;
  final List<List<int>> numbers;
  final Set<int> markedNumbers;

  const BingoCard({
    required this.id,
    required this.playerId,
    required this.roundId,
    required this.numbers,
    this.markedNumbers = const {},
  });

  int get markedCount => markedNumbers.length;

  bool isMarked(int number) {
    return markedNumbers.contains(number);
  }

  BingoCard markNumber(int number) {
    return BingoCard(
      id: id,
      playerId: playerId,
      roundId: roundId,
      numbers: numbers,
      markedNumbers: {
        ...markedNumbers,
        number,
      },
    );
  }
}
