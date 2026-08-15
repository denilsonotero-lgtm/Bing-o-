enum BingoTicketStatus {
  pending,
  checked,
  invalid,
  alreadyUsed,
}

class BingoTicket {
  final String id;
  final String roundId;
  final String playerId;
  final String cardId;
  final String modality;
  final int simultaneousWinners;
  final int virtualCredits;
  final DateTime createdAt;
  final BingoTicketStatus status;

  const BingoTicket({
    required this.id,
    required this.roundId,
    required this.playerId,
    required this.cardId,
    required this.modality,
    required this.simultaneousWinners,
    required this.virtualCredits,
    required this.createdAt,
    required this.status,
  });

  bool get isValid => status == BingoTicketStatus.pending;
}
