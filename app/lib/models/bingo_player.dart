enum BingoPlayerStatus {
  pending,
  active,
  blocked,
}

class BingoPlayer {
  final String id;
  final String name;
  final String username;
  final BingoPlayerStatus status;
  final int virtualCredits;

  const BingoPlayer({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.virtualCredits,
  });

  bool get isActive => status == BingoPlayerStatus.active;
}
