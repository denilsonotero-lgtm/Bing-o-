import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEnabled = true;
  bool voiceEnabled = true;
  bool vibrationEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Aparência',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: SwitchListTile(
              title: const Text('Modo escuro'),
              subtitle: const Text(
                'Usar aparência escura no aplicativo',
              ),
              secondary: const Icon(Icons.dark_mode),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Sorteio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Som da bola'),
                  subtitle: const Text(
                    'Reproduzir som durante o sorteio',
                  ),
                  secondary: const Icon(Icons.volume_up),
                  value: soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      soundEnabled = value;
                    });
                  },
                ),

                const Divider(height: 1),

                SwitchListTile(
                  title: const Text('Voz anunciadora'),
                  subtitle: const Text(
                    'Anunciar a bola por voz',
                  ),
                  secondary: const Icon(Icons.record_voice_over),
                  value: voiceEnabled,
                  onChanged: (value) {
                    setState(() {
                      voiceEnabled = value;
                    });
                  },
                ),

                const Divider(height: 1),

                SwitchListTile(
                  title: const Text('Vibração'),
                  subtitle: const Text(
                    'Vibrar quando uma nova bola aparecer',
                  ),
                  secondary: const Icon(Icons.vibration),
                  value: vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      vibrationEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Sobre',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('BINGÃO'),
              subtitle: Text('Versão 1.0.0'),
            ),
          ),
        ],
      ),
    );
  }
}
