import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';

class FarmDataFormDialog extends StatefulWidget {
  const FarmDataFormDialog({super.key});

  @override
  State<FarmDataFormDialog> createState() => _FarmDataFormDialogState();
}

class _FarmDataFormDialogState extends State<FarmDataFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? cropType;
  String? irrigationType;
  String? treeSpecies;
  double? farmSize;

  final List<String> cropTypes = [
    'Wheat', 'Rice', 'Maize', 'Sugarcane', 'Cotton', 'Soybean', 'Other'
  ];
  final List<String> irrigationTypes = [
    'Drip', 'Sprinkler', 'Flood', 'Manual', 'None'
  ];

  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => isLoading = true);
    try {
      final firebaseUser = AuthService.getCurrentUser();
      if (firebaseUser == null) throw Exception('User not logged in');
      await SupabaseService.saveFarmData(
        userId: firebaseUser.uid,
        cropType: cropType!,
        farmSize: farmSize!,
        irrigationType: irrigationType!,
        treeSpecies: treeSpecies ?? '',
      );
      if (mounted) Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm data saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Farm Data Entry',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Primary Crop Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.grass),
                ),
                items: cropTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                validator: (v) => v == null ? 'Required' : null,
                onChanged: (v) => setState(() => cropType = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Farm Size (hectares)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.square_foot),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => farmSize = double.tryParse(v ?? ''),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Irrigation Type',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.water),
                ),
                items: irrigationTypes.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                validator: (v) => v == null ? 'Required' : null,
                onChanged: (v) => setState(() => irrigationType = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tree Species (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.nature),
                ),
                onSaved: (v) => treeSpecies = v,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Submit', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
