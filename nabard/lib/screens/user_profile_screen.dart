import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'profile_form_dialog.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    profile = await SupabaseService.fetchUserProfile(user.id);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null || profile!.isEmpty
              ? const Center(child: Text('No profile found.'))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Full Name: ${profile!['full_name'] ?? ''}', style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 12),
                          Text('Village: ${profile!['village'] ?? ''}', style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 12),
                          Text('District: ${profile!['district'] ?? ''}', style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 12),
                          Text('State: ${profile!['state'] ?? ''}', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => const ProfileFormDialog(),
          );
          if (result == true) {
            setState(() {
              isLoading = true;
            });
            await _fetchProfile();
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
