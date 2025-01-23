import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePickerHelper {
  static Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static Future<void> uploadImage(File? imageFile, BuildContext context) async {
    if (imageFile == null) return;
    try {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';
      await Supabase.instance.client.storage
          .from('images')
          .upload(path, imageFile)
          .then((onValue) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image Uploaded successfully"))));
    } on Exception catch (e) {
      // TODO
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }
  
}
