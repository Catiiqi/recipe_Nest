import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageProvider extends ChangeNotifier {
  File? _profileImage;

  File? get profileImage => _profileImage;

  // Method to pick image
  Future<void> selectAndUploadImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage = File(image.path);
      notifyListeners();

      try {
        
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception("User not logged in");
        }

        // Generate a unique file name using uid and timestamp
        final fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'recipeUploads/$fileName';

        // Upload the image to Supabase storage
        // ignore: unused_local_variable
        final uploadResponse = await Supabase.instance.client.storage
            .from('images')
            .upload(path, _profileImage!);

        final publicUrl =
            Supabase.instance.client.storage.from('images').getPublicUrl(path);

        final recipeCollection = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Recipe');

        final snapshot = await recipeCollection.get();
        if (snapshot.docs.isNotEmpty) {
          final recipeDocId = snapshot.docs.first.id;

          await recipeCollection.doc(recipeDocId).update({
            'profileImageUrl': publicUrl,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload image: $e")),
        );
      }
    }
  }
}
