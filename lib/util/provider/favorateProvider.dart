import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final String userCredential = FirebaseAuth.instance.currentUser!.uid;

  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> get favorites => _favorites;
    List<Map<String, dynamic>> _favoritedRecipesDetails = [];  
  List<Map<String, dynamic>> get favoritedRecipesDetails => _favoritedRecipesDetails;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  bool _isLoading = false;
  bool get isLoading =>_isLoading;

  FavoriteProvider() {
    fetchFavorites();
  }

 
  Future<void> fetchFavorites() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential)
          .collection('Favorite')
          .get();

      
      _favorites = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

    Future<void> showAllfavoratedRecipe() async {
  try {
    _isLoading = true;
    notifyListeners();

    final favoriteRecipesSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userCredential)
        .collection('Favorite')
        .get();

    List<Map<String, dynamic>> favoritedRecipes = [];
    print("Fetching favorites...");

    for (var favorite in favoriteRecipesSnapshot.docs) {
      String favoriteRecipeId = favorite['FavoriteRecipeId'];
      
      print("Favorite RecipeId: $favoriteRecipeId");

      final recipeSnapshot = await FirebaseFirestore.instance
          .collection('Users').doc(userCredential).collection('Recipe')
          .doc(favoriteRecipeId)
          .get();

      if (recipeSnapshot.exists) {
        favoritedRecipes.add({
          'id': recipeSnapshot.id,
          ...recipeSnapshot.data() as Map<String, dynamic>,
        });
      }else{
          print("No recipe found for FavoriteRecipeId: $favoriteRecipeId");
      }
    }

    _favoritedRecipesDetails = favoritedRecipes;
    print("Favorites fetched: ${_favoritedRecipesDetails.length}");
    _isLoading = false;
    notifyListeners();  
  } catch (e) {
    print('Error fetching favorited recipes: $e');
  }
}



  Future<void> toggleFavorite(String recipeId) async {
    try {
      
      CollectionReference<Map<String, dynamic>> favoriteCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential)
          .collection('Favorite');

      
      final querySnapshot = await favoriteCollection
          .where('FavoriteRecipeId', isEqualTo: recipeId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        
        await favoriteCollection.doc(querySnapshot.docs.first.id).delete();
        _isFavorite = false;
      } else {
        
        await favoriteCollection.add({'FavoriteRecipeId': recipeId});
        _isFavorite = true;
      }

      
      fetchFavorites();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  
  Future<bool> isRecipeFavorited(String recipeId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential)
          .collection('Favorite')
          .where('FavoriteRecipeId', isEqualTo: recipeId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }
}
