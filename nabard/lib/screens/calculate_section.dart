import 'package:flutter/material.dart';

class CalculateSection extends StatelessWidget {
  const CalculateSection({super.key});

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
              const Icon(Icons.calculate, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Text('Carbon Credit Calculations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('IPCC Tier 1/2 guidelines with Indian emission factors', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 20),
          // Crop-based CO2e Card
          _CalculationCard(
            title: 'Crop-based CO₂e',
            tag: 'Rice',
            items: const [
              _CalculationItem(label: 'CH₄ Reduction', value: '12.5 kg CO₂e'),
              _CalculationItem(label: 'N₂O Reduction', value: '8.2 kg CO₂e'),
            ],
          ),
          const SizedBox(height: 12),
          // Tree-based CO2e Card
          _CalculationCard(
            title: 'Tree-based CO₂e',
            tag: 'Mango',
            items: const [
              _CalculationItem(label: 'Biomass Sequestration', value: '207.6 kg CO₂e'),
              _CalculationItem(label: 'Survival Rate', value: '85%'),
            ],
          ),
          const SizedBox(height: 12),
          // Total Season Credits Card
          _TotalCreditsCard(),
          const SizedBox(height: 20),
          // Recalculate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, color: Colors.white),
              label: const Text('Recalculate with Latest Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculationCard extends StatelessWidget {
  final String title;
  final String tag;
  final List<_CalculationItem> items;

  const _CalculationCard({required this.title, required this.tag, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 8),
                ...items,
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tag, style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _CalculationItem extends StatelessWidget {
  final String label;
  final String value;

  const _CalculationItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCreditsCard extends StatelessWidget {
  const _TotalCreditsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Total Season Credits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 8),
                Text('After 10% GS buffer applied', style: TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('2.4 tCO₂e', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Gold Standard', style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
