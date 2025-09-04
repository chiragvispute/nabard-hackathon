import 'package:flutter/material.dart';
import 'monitor_section.dart';
import 'calculate_section.dart';
import 'report_section.dart';

class CreditsTabView extends StatefulWidget {
  const CreditsTabView({super.key});

  @override
  State<CreditsTabView> createState() => _CreditsTabViewState();
}

class _CreditsTabViewState extends State<CreditsTabView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _tab('Monitor', 0),
            _tab('Calculate', 1),
            _tab('Report', 2),
          ],
        ),
        const SizedBox(height: 16),
        if (_selectedTab == 0) ...[
          const MonitorSection(),
        ] else if (_selectedTab == 1) ...[
          const CalculateSection(),
        ] else if (_selectedTab == 2) ...[
          const ReportSection(),
        ],
      ],
    );
  }

  Widget _tab(String label, int tabIndex) {
    final selected = _selectedTab == tabIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabIndex;
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
