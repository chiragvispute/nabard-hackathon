import 'package:flutter/material.dart';
import 'farm_data_form_dialog.dart';
import 'take_photo_dialog.dart';
import 'farm_boundary_dialog.dart';

class SubmitSection extends StatelessWidget {
  const SubmitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SubmitCard(
                icon: Icons.assignment,
                title: 'Farm Data',
                subtitle: 'Enter details',
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const FarmDataFormDialog(),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SubmitCard(
                icon: Icons.camera_alt,
                title: 'Take Photo',
                subtitle: 'Upload or Capture',
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const TakePhotoDialog(),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SubmitCard(
                icon: Icons.map,
                title: 'Farm Boundary',
                subtitle: 'Draw Polygon',
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FarmBoundaryDialog(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SubmitCard(
                icon: Icons.water,
                title: 'Water Usage',
                subtitle: 'Irrigation Data',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SubmitCard(
                icon: Icons.eco,
                title: 'Crop Data',
                subtitle: 'Growth Stage',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubmitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SubmitCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, color: Colors.green, size: 32),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}
