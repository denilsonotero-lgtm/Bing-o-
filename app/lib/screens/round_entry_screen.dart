import 'package:flutter/material.dart';

class RoundEntryScreen extends StatelessWidget {
  const RoundEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int participants = 128;
    const int minimumParticipants = 20;
    const int availableCredits = 150;
    const int entryCost = 10;
    const bool userApproved = true;

    final bool minimumReached =
        participants >= minimumParticipants;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar na rodada'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        '🎱',
                        style: TextStyle(fontSize: 60),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'RODADA #001284',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _InfoRow(
                        icon: Icons.people,
                        title: 'Participantes',
                        value:
                            '$participants / ilimitado',
                      ),

                      _InfoRow(
                        icon: Icons.flag,
                        title: 'Mínimo para iniciar',
                        value:
                            '$minimumParticipants',
                      ),

                      _InfoRow(
                        icon: Icons.confirmation_number,
                        title: 'Valor da entrada',
                        value:
                            '$entryCost créditos',
                      ),

                      _InfoRow(
                        icon: Icons.account_balance_wallet,
                        title: 'Seu saldo',
                        value:
                            '$availableCredits créditos',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: Icon(
                    userApproved
                        ? Icons.verified
                        : Icons.block,
                  ),
                  title: Text(
                    userApproved
                        ? 'Usuário liberado'
                        : 'Usuário não liberado',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    userApproved
                        ? 'Você pode participar desta rodada.'
                        : 'Aguarde a liberação.',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: Icon(
                    minimumReached
                        ? Icons.check_circle
                        : Icons.hourglass_bottom,
                  ),
                  title: Text(
                    minimumReached
                        ? 'Mínimo atingido'
                        : 'Aguardando participantes',
                  ),
                  subtitle: Text(
                    minimumReached
                        ? 'A rodada pode iniciar.'
                        : 'Precisamos de mais participantes.',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed:
                      userApproved &&
                              availableCredits >=
                                  entryCost
                          ? () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Entrada será conectada ao sistema na próxima etapa.',
                                  ),
                                ),
                              );
                            }
                          : null,
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                  label: Text(
                    'ENTRAR • $entryCost CRÉDITOS',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'O crédito será reservado antes da rodada. '
                'Se a rodada não iniciar por falta do mínimo, '
                'o crédito será devolvido.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
