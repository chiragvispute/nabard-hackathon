import 'package:flutter/material.dart';

class ReportSection extends StatelessWidget {
  const ReportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Gold Standard Reports', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Generate compliant MRV reports for verification', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 20),
          // Credits Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.emoji_events, color: Colors.green, size: 40),
                const SizedBox(height: 8),
                const Text('2.4 tCO₂e', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 4),
                const Text('Total Credits This Season', style: TextStyle(fontSize: 16, color: Colors.green)),
                const SizedBox(height: 4),
                const Text('₹ Estimated Value: ₹5,760', style: TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Report Actions
          _ReportActionButton(
            icon: Icons.picture_as_pdf,
            label: 'Generate PDF Report',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _ReportActionButton(
            icon: Icons.download,
            label: 'Export CSV Data',
            onTap: () {},
          ),
          const SizedBox(height: 8),
          _ReportActionButton(
            icon: Icons.map,
            label: 'Download GeoJSON',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          // Verification Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified_user, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    const Text('Verification Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('✓ SHA256 hash verification complete', style: TextStyle(fontSize: 14, color: Colors.black)),
                const Text('✓ GPS validation passed', style: TextStyle(fontSize: 14, color: Colors.black)),
                const Text('✓ Satellite cross-check successful', style: TextStyle(fontSize: 14, color: Colors.black)),
                const Text('✓ QA/QC confidence score: 87%', style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReportActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.green),
        label: Text(label, style: const TextStyle(color: Colors.green)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          side: const BorderSide(color: Colors.green, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onTap,
      ),
    );
  }
}
