import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> saveProfile({
    required String fullName,
    required String village,
    required String district,
    required String state,
    required String userId,
  }) async {
    await client.from('profiles').upsert({
      'user_id': userId,
      'full_name': fullName,
      'village': village,
      'district': district,
      'state': state,
    });
  }

  static Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final data = await client
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .single();
    return data;
  }
}
