enum BingoRoundStatus {
  scheduled,
  waitingMinimum,
  running,
  paused,
  finished,
  cancelled,
}

enum BingoDrawMode {
  automatic,
  manual,
}

class BingoRound {
  final String id;
  final String name;
  final DateTime scheduledAt;
  final BingoRoundStatus status;
  final BingoDrawMode drawMode;
  final int minimumCards;
  final int currentBall;
  final List<int> drawnBalls;

  const BingoRound({
    required this.id,
    required this.name,
    required this.scheduledAt,
    required this.status,
    required this.drawMode,
    required this.minimumCards,
    this.currentBall = 0,
    this.drawnBalls = const [],
  });

  bool get isRunning => status == BingoRoundStatus.running;

  bool get isFinished => status == BingoRoundStatus.finished;
}
