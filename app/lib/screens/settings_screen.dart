import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  // Opções de áudio e acessibilidade
  bool _drawSoundEnabled = true;
  bool _voiceAnnounceEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'ÁUDIO E EFEITOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Efeitos de Áudio'),
            subtitle: const Text('Tocar som no sorteio das bolas'),
            value: _drawSoundEnabled,
            onChanged: (value) {
              setState(() {
                _drawSoundEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Voz de Anúncio'),
            subtitle: const Text('Anunciar o número da bola sorteada'),
            value: _voiceAnnounceEnabled,
            onChanged: (value) {
              setState(() {
                _voiceAnnounceEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Vibração'),
            subtitle: const Text('Vibrar ao sortear uma nova bola'),
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          const Text(
            'APARÊNCIA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Modo Escuro'),
            subtitle: const Text('Utilizar tema escuro no aplicativo'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          const Divider(height: 32),
          const Text(
            'CONTA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Sair da Conta',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
