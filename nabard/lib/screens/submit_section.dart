import 'package:flutter/material.dart';
import 'farm_data_form_dialog.dart';
import 'take_photo_dialog.dart';
import 'farm_boundary_dialog.dart';

class SubmitSection extends StatelessWidget {
  const SubmitSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _SubmitCard(
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
                _SubmitCard(
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
                _SubmitCard(
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
                _SubmitCard(
                  icon: Icons.water,
                  title: 'Water Usage',
                  subtitle: 'Irrigation Data',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.8,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.water, color: Colors.blue, size: 32),
                                      SizedBox(width: 12),
                                      Text('Water Usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Enter irrigation details, water source, and usage for your farm.'),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Water Source',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Amount Used (litres)',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Irrigation Method',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save Water Usage'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _SubmitCard(
                  icon: Icons.eco,
                  title: 'Crop Data',
                  subtitle: 'Enter crop details',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.8,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.eco, color: Colors.green, size: 32),
                                      SizedBox(width: 12),
                                      Text('Crop Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('Enter crop type, growth stage, and other relevant details.'),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Crop Type',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Growth Stage',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Area Covered (hectares)',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save Crop Data'),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 120, // Prevent overflow in card
            ),
            child: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
