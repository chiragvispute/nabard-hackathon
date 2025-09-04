import 'package:flutter/material.dart';
import 'take_photo_dialog.dart';
import 'farm_data_form_dialog.dart';
import 'farm_boundary_dialog.dart';
import 'monitor_section.dart';
import 'calculate_section.dart';
import 'report_section.dart';
import 'submit_section.dart';

class CollectSection extends StatefulWidget {
  const CollectSection({super.key});

  @override
  State<CollectSection> createState() => _CollectSectionState();
}

class _CollectSectionState extends State<CollectSection> {
  int selectedTab = 0; // 0: Collect, 1: Monitor, 2: Calculate, 3: Report

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
              _tab('Collect', 0),
              _tab('Monitor', 1),
              _tab('Calculate', 2),
              _tab('Report', 3),
            ],
          ),
        ),
        // Tab content
        if (selectedTab == 0) ...[
          // Only Quick Data Entry section remains in Collect tab
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
        ] else if (selectedTab == 1) ...[
          // Monitor Section UI
          const MonitorSection(),
        ] else if (selectedTab == 2) ...[
          // Calculate Section UI
          const CalculateSection(),
        ] else if (selectedTab == 3) ...[
          // Report Section UI
          const ReportSection(),
        ] else ...[
          // Placeholder for other tabs
          Container(
            height: 200,
            alignment: Alignment.center,
            child: const Text('Coming Soon...', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
        ],
      ],
    );
  }

  Widget _tab(String label, int tabIndex) {
    final selected = selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tabIndex;
          });
        },
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
