import 'package:flutter/material.dart';
import 'take_photo_dialog.dart';
import 'farm_data_form_dialog.dart';
import 'farm_boundary_dialog.dart';

class CollectSection extends StatelessWidget {
  const CollectSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row tabs
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              _tab('Collect', true),
              _tab('Monitor', false),
              _tab('Calculate', false),
              _tab('Report', false),
            ],
          ),
        ),
        // Cards row
        Row(
          children: [
            Expanded(
              child: _CollectCard(
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
              child: _CollectCard(
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
              child: _CollectCard(
                icon: Icons.map,
                title: 'Farm Boundary',
                subtitle: 'Draw Polygon',
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => const FarmBoundaryDialog(),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CollectCard(
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
              child: _CollectCard(
                icon: Icons.eco,
                title: 'Crop Data',
                subtitle: 'Growth Stage',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Quick Data Entry section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Quick Data Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.nature),
                      label: const Text('Tree Count'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.thermostat),
                      label: const Text('Soil Temp'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Upload Voice Note'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tab(String label, bool selected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: selected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Center(
          child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: selected ? Colors.green : Colors.black)),
        ),
      ),
    );
  }
}

class _CollectCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CollectCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

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
