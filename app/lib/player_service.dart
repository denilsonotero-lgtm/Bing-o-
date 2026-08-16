import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Busca o perfil do jogador logado usando o auth_user_id
  Future<Map<String, dynamic>?> getCurrentPlayerProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('players')
        .select()
        .eq('auth_user_id', user.id)
        .maybeSingle();

    return response;
  }

  /// Cria o registro inicial do jogador na tabela players
  Future<void> createPlayerProfile({
    required String username,
    required String displayName,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado.');

    await _supabase.from('players').insert({
      'auth_user_id': user.id,
      'username': username,
      'display_name': displayName,
      'virtual_credits': 0,
    });
  }
}
