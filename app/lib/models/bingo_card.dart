class BingoCard {
  final String id;
  final String playerId;
  final String roundId;
  final List<List<int?>> numbers;

  const BingoCard({
    required this.id,
    required this.playerId,
    required this.roundId,
    required this.numbers,
  });

  int get markedCount {
    return numbers
        .expand((row) => row)
        .where((number) => number == null)
        .length;
  }
}
