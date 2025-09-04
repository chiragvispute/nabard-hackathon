import 'package:flutter/material.dart';

class MonitorSection extends StatelessWidget {
  const MonitorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rainfall Card
        _MonitorCard(
          icon: Icons.grain,
          title: 'Rainfall',
          value: '120 mm',
          subtitle: 'This Month',
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        // Temperature Card
        _MonitorCard(
          icon: Icons.thermostat,
          title: 'Temperature',
          value: '28°C',
          subtitle: 'Current',
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        // Recent Activity Card
        _MonitorCard(
          icon: Icons.history,
          title: 'Recent Activity',
          value: '3 updates',
          subtitle: 'Last 7 days',
          color: Colors.green,
        ),
      ],
    );
  }
}

class _MonitorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _MonitorCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
