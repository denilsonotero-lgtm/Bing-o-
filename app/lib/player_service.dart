import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> createPlayer({
    required String name,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _supabase.from('players').insert({
      'auth_user_id': user.id,
      'name': name,
    });
  }

  Future<Map<String, dynamic>?> getMyPlayer() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final result = await _supabase
        .from('players')
        .select()
        .eq('auth_user_id', user.id)
        .maybeSingle();

    return result;
  }
}
