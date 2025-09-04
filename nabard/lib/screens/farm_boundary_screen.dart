import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmBoundaryScreen extends StatefulWidget {
  const FarmBoundaryScreen({super.key});

  @override
  State<FarmBoundaryScreen> createState() => _FarmBoundaryScreenState();
}

class _FarmBoundaryScreenState extends State<FarmBoundaryScreen> {
  List<LatLng> _polygonPoints = [];
  bool _drawing = false;
  String? ndviImageUrl;
  bool _loadingNdvi = false;

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
    });
  }

  Future<void> _saveBoundary() async {
  // Save to Supabase (as array of lat/lng)
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return;
  final coords = _polygonPoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList();
  await SupabaseService.saveFarmBoundary(user.id, coords);
    setState(() {
      _drawing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Farm boundary saved!')),
    );
  }

  Future<void> _fetchNdvi() async {
    setState(() { _loadingNdvi = true; });
    final coords = _polygonPoints.map((p) => [p.longitude, p.latitude]).toList();
    final url = 'http://192.168.190.237:5000/gee/ndvi'; // Replace with your backend URL
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draw Farm Boundary'), backgroundColor: Colors.green),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(20.5937, 78.9629),
              zoom: 5,
              onTap: (tapPosition, point) => _onMapTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                attributionBuilder: (_) {
                  return Text('© ESRI World Imagery');
                },
                // ESRI ArcGIS World Imagery satellite view with attribution
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
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
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
    );
  }
}
