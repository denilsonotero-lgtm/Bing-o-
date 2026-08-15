import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void register() {
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showMessage('Preencha todos os campos.');
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showMessage('As senhas não coincidem.');
      return;
    }

    showMessage(
      'Cadastro será conectado ao Supabase na próxima etapa.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar cadastro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '🎱',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 65),
              ),

              const SizedBox(height: 8),

              const Text(
                'Criar sua conta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: register,
                  icon: const Icon(Icons.person_add),
                  label: const Text('CRIAR CONTA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
