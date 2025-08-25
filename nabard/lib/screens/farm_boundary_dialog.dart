import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/supabase_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class FarmBoundaryDialog extends StatefulWidget {
  const FarmBoundaryDialog({super.key});

  @override
  State<FarmBoundaryDialog> createState() => _FarmBoundaryDialogState();
}

class _FarmBoundaryDialogState extends State<FarmBoundaryDialog> {
  List<LatLng> _polygonPoints = [];
  bool _drawing = false;
  String? ndviImageUrl;
  bool _loadingNdvi = false;
  TextEditingController _searchController = TextEditingController();
  MapController _mapController = MapController();

  void _onMapTap(LatLng point) {
    if (_drawing) {
      setState(() {
        _polygonPoints.add(point);
      });
    }
  }

  void _startDrawing() {
    setState(() {
      _drawing = true;
      _polygonPoints = [];
      ndviImageUrl = null;
    });
  }

  Future<void> _saveBoundary() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final coords = _polygonPoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList();
    await SupabaseService.saveFarmBoundary(user.id, coords);
    setState(() {
      _drawing = false;
    });
    if (mounted) Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Farm boundary saved!')),
    );
  }

  Future<void> _fetchNdvi() async {
    setState(() { _loadingNdvi = true; });
    final coords = _polygonPoints.map((p) => [p.longitude, p.latitude]).toList();
    final url = 'http://192.168.0.100:5000/gee/ndvi'; // Replace with your backend URL
    final body = jsonEncode({'coordinates': coords});
    final response = await http.post(Uri.parse(url), body: body, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      setState(() {
        ndviImageUrl = jsonDecode(response.body)['thumb_url'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch NDVI: ${response.body}')),
      );
    }
    setState(() { _loadingNdvi = false; });
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    final response = await http.get(url, headers: {'User-Agent': 'nabard-hackathon-app'});
    if (response.statusCode == 200) {
      final results = jsonDecode(response.body);
      if (results.isNotEmpty) {
        final lat = double.parse(results[0]['lat']);
        final lon = double.parse(results[0]['lon']);
        _mapController.move(LatLng(lat, lon), 16.0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Moved to $query')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location not found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 540,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search location...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                      onSubmitted: (_) => _searchLocation(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _searchLocation,
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(20.5937, 78.9629),
                      zoom: 5,
                      onTap: (tapPosition, point) => _onMapTap(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: _polygonPoints,
                            color: Colors.green.withOpacity(0.2),
                            borderColor: Colors.green,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (ndviImageUrl != null)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.network(ndviImageUrl!, fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _startDrawing,
                      child: const Text('Start Drawing'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _polygonPoints.length > 2 ? _saveBoundary : null,
                      child: const Text('Save Boundary'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _polygonPoints.length > 2 && !_loadingNdvi ? _fetchNdvi : null,
                      child: _loadingNdvi ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Get NDVI'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
