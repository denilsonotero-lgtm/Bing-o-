import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> createPlayer({
    required String userName,
    required String displayName,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _supabase.from('players').insert({
  'username': userName,
  'display_name': displayName,
  'virtual_credits': 0,
  'auth_uuid': user.id,
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
        .eq('auth_uuid', user.id)
        .maybeSingle();

    return result;
  }
}
