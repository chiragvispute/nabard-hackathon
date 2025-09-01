import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';
import 'dart:io';

class TakePhotoDialog extends StatefulWidget {
  const TakePhotoDialog({super.key});

  @override
  State<TakePhotoDialog> createState() => _TakePhotoDialogState();
}

class _TakePhotoDialogState extends State<TakePhotoDialog> {
  bool isLoading = false;
  List<XFile> photos = [];
  double? lastLatitude;
  double? lastLongitude;
  String? selectedSeason;
  final List<String> seasons = ['Kharif', 'Rabi', 'Summer', 'Other'];

  Future<void> _pickPhotos(ImageSource source) async {
    setState(() => isLoading = true);
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        photos.addAll(pickedFiles);
        // Get location
        Position? position;
        try {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            await Geolocator.openLocationSettings();
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
          }
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.deniedForever) {
            throw Exception('Location permissions are permanently denied');
          }
          position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        } catch (e) {
          position = null;
        }
        lastLatitude = position?.latitude;
        lastLongitude = position?.longitude;
        // Now wait for user to confirm saving
      }
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Take or Upload Photos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSeason,
              items: seasons.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedSeason = val),
              decoration: const InputDecoration(
                labelText: 'Season',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('Select Multiple Photos'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: isLoading ? null : () => _pickPhotos(ImageSource.gallery),
            ),
            const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Multiple Photos (Camera)'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: isLoading ? null : () async {
                  // Camera does not support pickMultiImage, so allow repeated capture
                  final picker = ImagePicker();
                  List<XFile> cameraPhotos = [];
                  bool addMore = true;
                  while (addMore) {
                    final photo = await picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      cameraPhotos.add(photo);
                      // Ask user if they want to take another photo
                      addMore = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Add another photo?'),
                          content: const Text('Do you want to take another photo with the camera?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
                          ],
                        ),
                      ) ?? false;
                    } else {
                      addMore = false;
                    }
                  }
                  if (cameraPhotos.isNotEmpty) {
                    setState(() => photos.addAll(cameraPhotos));
                    // Save each photo info to Supabase (add location and season)
                    Position? position;
                    try {
                      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                      if (!serviceEnabled) {
                        await Geolocator.openLocationSettings();
                        serviceEnabled = await Geolocator.isLocationServiceEnabled();
                      }
                      LocationPermission permission = await Geolocator.checkPermission();
                      if (permission == LocationPermission.denied) {
                        permission = await Geolocator.requestPermission();
                      }
                      if (permission == LocationPermission.deniedForever) {
                        throw Exception('Location permissions are permanently denied');
                      }
                      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                    } catch (e) {
                      position = null;
                    }
                    final firebaseUser = AuthService.getCurrentUser();
                    if (firebaseUser == null) throw Exception('User not logged in');
                    for (final photo in cameraPhotos) {
                      await SupabaseService.saveFarmPhoto(
                        userId: firebaseUser.uid,
                        photoPath: photo.path,
                        latitude: position?.latitude,
                        longitude: position?.longitude,
                        season: selectedSeason,
                      );
                    }
                    if (mounted) Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Camera photos saved with GPS and season!')),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            if (photos.isNotEmpty) ...[
              Text('Selected: ${photos.length} photos', textAlign: TextAlign.center),
              if (lastLatitude != null && lastLongitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'GPS: ${lastLatitude!.toStringAsFixed(6)}, ${lastLongitude!.toStringAsFixed(6)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photos.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.file(
                      File(photos[i].path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Photos'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: isLoading ? null : () async {
                  setState(() => isLoading = true);
                  try {
                    final firebaseUser = AuthService.getCurrentUser();
                    if (firebaseUser == null) throw Exception('User not logged in');
                    for (final photo in photos) {
                      await SupabaseService.saveFarmPhoto(
                        userId: firebaseUser.uid,
                        photoPath: photo.path,
                        latitude: lastLatitude,
                        longitude: lastLongitude,
                        season: selectedSeason,
                      );
                    }
                    if (mounted) Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photos saved with GPS and season!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  } finally {
                    setState(() => isLoading = false);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
