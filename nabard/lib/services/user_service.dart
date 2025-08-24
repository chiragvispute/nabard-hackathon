import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class UserService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  // Register a new user
  Future<bool> registerUser({
    required String phoneNumber,
    required String fullName,
    required String language,
    required double farmSize,
    required String farmType,
    required String location,
    required String state,
    required String aadhaarNumber,
    required bool consentGiven,
  }) async {
    try {
      // Check if user already exists
      final existingUser =
          await _supabase
              .from('farmers')
              .select('id')
              .eq('phone_number', phoneNumber)
              .maybeSingle();

      if (existingUser != null) {
        // User exists, update their information
        await _supabase
            .from('farmers')
            .update({
              'full_name': fullName,
              'preferred_language': language,
              'farm_size_acres': farmSize,
              'farm_type': farmType,
              'village': location,
              'state': state,
              'aadhaar_number': aadhaarNumber,
              'consent_given': consentGiven,
            })
            .eq('phone_number', phoneNumber);
      } else {
        // Create new user
        await _supabase.from('farmers').insert({
          'phone_number': phoneNumber,
          'full_name': fullName,
          'preferred_language': language,
          'farm_size_acres': farmSize,
          'farm_type': farmType,
          'village': location,
          'state': state,
          'aadhaar_number': aadhaarNumber,
          'consent_given': consentGiven,
        });
      }

      print('User registered successfully: $phoneNumber');
      return true;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String phoneNumber) async {
    try {
      final response =
          await _supabase
              .from('farmers')
              .select('*')
              .eq('phone_number', phoneNumber)
              .maybeSingle();

      return response;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Check if user registration is complete
  Future<bool> isRegistrationComplete(String phoneNumber) async {
    try {
      final response =
          await _supabase
              .from('farmers')
              .select('full_name, aadhaar_number')
              .eq('phone_number', phoneNumber)
              .maybeSingle();

      // Check if user exists and has essential fields filled
      return response != null &&
          response['full_name'] != null &&
          response['aadhaar_number'] != null;
    } catch (e) {
      print('Error checking registration status: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(
    String phoneNumber,
    Map<String, dynamic> data,
  ) async {
    try {
      await _supabase
          .from('farmers')
          .update(data)
          .eq('phone_number', phoneNumber);

      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Delete user account
  Future<bool> deleteUser(String phoneNumber) async {
    try {
      await _supabase.from('farmers').delete().eq('phone_number', phoneNumber);

      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Get farmers by state (for analytics/admin)
  Future<List<Map<String, dynamic>>> getFarmersByState(String state) async {
    try {
      final response = await _supabase
          .from('farmers')
          .select('*')
          .eq('state', state);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting farmers by state: $e');
      return [];
    }
  }

  // Get total registered farmers count
  Future<int> getTotalFarmersCount() async {
    try {
      final response = await _supabase.from('farmers').select('id');

      return response.length;
    } catch (e) {
      print('Error getting farmers count: $e');
      return 0;
    }
  }
}
