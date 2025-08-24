import 'package:flutter/material.dart';

class ProfileViewDialog extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileViewDialog({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: Text(profile['full_name'] ?? ''),
              subtitle: const Text('Full Name'),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.green),
              title: Text(profile['village'] ?? ''),
              subtitle: const Text('Village'),
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.green),
              title: Text(profile['state'] ?? ''),
              subtitle: const Text('State'),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
