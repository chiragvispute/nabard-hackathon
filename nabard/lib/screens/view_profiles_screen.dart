import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ViewProfilesScreen extends StatefulWidget {
  const ViewProfilesScreen({super.key});

  @override
  State<ViewProfilesScreen> createState() => _ViewProfilesScreenState();
}

class _ViewProfilesScreenState extends State<ViewProfilesScreen> {
  late Future<List<Map<String, dynamic>>> _profilesFuture;

  @override
  void initState() {
    super.initState();
    _profilesFuture = SupabaseService.fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _profilesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final profiles = snapshot.data ?? [];
          if (profiles.isEmpty) {
            return const Center(child: Text('No profiles found.'));
          }
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, i) {
              final p = profiles[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(p['full_name'] ?? ''),
                  subtitle: Text('Village: ${p['village'] ?? ''}\nDistrict: ${p['district'] ?? ''}\nState: ${p['state'] ?? ''}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
