import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FoodCatogory { vegetarian, omnivorous, drinks, deserts }

class RecipeProvider with ChangeNotifier {
  // ignore: unused_field
  late FoodCatogory _catogory;
  bool _isSaving = false;
  bool get isSaving => _isSaving;

  List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = true;
  File? _profileImage;
  String? _publicImgUrl;
  String? get publicImgUrl => _publicImgUrl;
  File? get profileImage => _profileImage;

  List<Map<String, dynamic>> get recipes => _recipes;
  bool get isLoading => _isLoading;

  RecipeProvider() {
    fetchRecipes();
  }

  void clearImge() {
    _profileImage = null;
    _publicImgUrl = null;
    notifyListeners();
  }

  Future<void> deleteRecipe(recipeId) async {
    final userCredential = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential)
        .collection('Recipe')
        .doc(recipeId)
        .delete();

    _recipes.removeWhere((recipe) => recipe['id'] == recipeId);
    notifyListeners();
  }

  Future<void> fetchRecipes() async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('Recipe')
          .orderBy('createdAt', descending: true)
          .get();

      _recipes = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCurrentRecipe(BuildContext context, recipeId,
      String recipeIngrident, String recipeSteps) async {
    final userCredential =  FirebaseAuth.instance.currentUser!.uid;
    try {
      final user =  FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential)
          .collection('Recipe')
          .doc(recipeId)
          .update(
              {'recipeIngrident': recipeIngrident, 'recipeSteps': recipeSteps});
        
      final recipeIndex =
          _recipes.indexWhere((recipe) => recipe['id'] == recipeId);

      /*or 0 */
      if (recipeIndex != -1) {
        _recipes[recipeIndex]['recipeIngrident'] = recipeIngrident;
        _recipes[recipeIndex]['recipeSteps'] = recipeSteps;
        notifyListeners();
      }

      Navigator.of(context).pop(true);
      Navigator.of(context).pop(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated ')),
      );
      notifyListeners();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> createNewRecipe(BuildContext context, String recipeName,
      String recipeIngrident, String recipeSteps, FoodCatogory category) async {
    final userCredential = FirebaseAuth.instance.currentUser!.uid;
    if (recipeName.isEmpty ||
        recipeIngrident.isEmpty ||
        recipeIngrident.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error Please Fill all filds")),
      );
      return;
    }
    _isSaving = true;
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
      if (_profileImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ُImage Is Required Please Try again")),
        );
        _isSaving = false;

        notifyListeners();

        return;
      } else {
        await Supabase.instance.client.storage
            .from('images')
            .upload(path, _profileImage!);
      }

      final publicUrl =
          Supabase.instance.client.storage.from('images').getPublicUrl(path);

      _publicImgUrl = publicUrl;

      final docRef = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential)
          .collection('Recipe')
          .add({
        'recipeName': recipeName,
        'recipeIngrident': recipeIngrident,
        'recipeSteps': recipeSteps,
        'profileImage': _publicImgUrl,
        'category': category.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp()
      });

      // Add the new recipe to the provider's list
      _recipes.add({
        'id': docRef.id,
        'recipeName': recipeName,
        'recipeIngrident': recipeIngrident,
        'recipeSteps': recipeSteps,
        'profileImage': _publicImgUrl,
        'category': category.toString().split('.').last,
        'createdAt': FieldValue.serverTimestamp()
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved successfully!")),
      );
      notifyListeners(); // Update the UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ُError: $e")),
      );
      print(e);
      // rethrow;
    }
    _isSaving = false;
    notifyListeners();
  }

  Future<void> selectAndUploadImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage = File(image.path);
      notifyListeners();
    }
  }
  //?new Filter ones?

  List<Map<String, dynamic>> get vegetarianRecipes {
    return _recipes
        .where((recipe) => recipe['category'] == 'vegetarian')
        .toList();
  }

  List<Map<String, dynamic>> get omnivorousRecipes {
    return _recipes
        .where((recipe) => recipe['category'] == 'omnivorous')
        .toList();
  }

  List<Map<String, dynamic>> get drinksRecipes {
    return _recipes.where((recipe) => recipe['category'] == 'drinks').toList();
  }

  List<Map<String, dynamic>> get desertsRecipes {
    return _recipes.where((recipe) => recipe['category'] == 'deserts').toList();
  }

  List<Map<String, dynamic>> get allRecipes {
    return _recipes;
  }

  String _selectedCategory = 'all';
  String get selectedCategory => _selectedCategory;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredRecipes {
    if (_selectedCategory == 'vegetarian') {
      return vegetarianRecipes;
    } else if (_selectedCategory == 'omnivorous') {
      return omnivorousRecipes;
    } else if (_selectedCategory == 'drinks') {
      return drinksRecipes;
    } else if (_selectedCategory == 'deserts') {
      return desertsRecipes;
    } else {
      return allRecipes;
    }
  }

  void searchRecipes(String query) {
    if (query.isEmpty) {
      fetchRecipes();
      return;
    }

    _recipes = _recipes.where((recipe) {
      final recipeName = recipe['recipeName']?.toLowerCase() ?? '';
      return recipeName.contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
