import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> saveFarmBoundary(String userId, List<Map<String, double>> coordinates) async {
    await client.from('farm_boundaries').upsert({
      'user_id': userId,
      'boundary': coordinates,
    });
  }
  static Future<List<Map<String, dynamic>>> fetchProfiles() async {
    final data = await client.from('profiles').select();
    return List<Map<String, dynamic>>.from(data);
  }
  static Future<void> saveFarmPhoto({
    required String userId,
    required String photoPath,
  }) async {
    await client.from('photos').upsert({
      'user_id': userId,
      'photo_url': photoPath,
    });
  }
  static Future<void> saveFarmData({
    required String userId,
    required String cropType,
    required double farmSize,
    required String irrigationType,
    required String treeSpecies,
  }) async {
    await client.from('farm_data').upsert({
      'user_id': userId,
      'crop_type': cropType,
      'farm_size': farmSize,
      'irrigation_type': irrigationType,
      'tree_species': treeSpecies,
    });
  }
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
