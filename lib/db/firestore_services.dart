import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {

  final userCredential = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createNewRecipe(
      String recipeName, String recipeIngrident, String recipeSteps) async {
    

    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential)
          .collection('Recipe')
          .add({
        'recipeName': recipeName,
        'recipeIngrident': recipeIngrident,
        'recipeSteps': recipeSteps // Initial empty bio
      });
      print('Succeded');
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteRecipe(recipeId) async {
    
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential)
        .collection('Recipe')
        .doc(recipeId)
        .delete();
  }

  Stream<QuerySnapshot> getRecipeFromFirebase() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Recipe")
        .snapshots();
  }

  Stream<QuerySnapshot> getProfileFromFirebase() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Profile")
        .snapshots();
  }
}
