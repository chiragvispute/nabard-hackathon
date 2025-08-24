import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';

class TakePhotoDialog extends StatefulWidget {
  const TakePhotoDialog({super.key});

  @override
  State<TakePhotoDialog> createState() => _TakePhotoDialogState();
}

class _TakePhotoDialogState extends State<TakePhotoDialog> {
  bool isLoading = false;
  String? photoPath;

  Future<void> _pickPhoto(ImageSource source) async {
    setState(() => isLoading = true);
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        photoPath = pickedFile.path;
        // Save photo info to Supabase (just path for now, you can upload to Supabase Storage if needed)
        final firebaseUser = AuthService.getCurrentUser();
        if (firebaseUser == null) throw Exception('User not logged in');
        await SupabaseService.saveFarmPhoto(
          userId: firebaseUser.uid,
          photoPath: photoPath!,
        );
        if (mounted) Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo info saved!')),
        );
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
            const Text('Take or Upload Photo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: isLoading ? null : () => _pickPhoto(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Photo'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
              onPressed: isLoading ? null : () => _pickPhoto(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
