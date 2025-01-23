import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //geting instence of firebse auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
//google sign in

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Retrieve the user information
    final User? user = userCredential.user;

    if (user != null) {
      // Check if the user document already exists
      final userDoc =
          FirebaseFirestore.instance.collection("Users").doc(user.uid);
      final docSnapshot = await userDoc.collection('Profile').get();
      if (docSnapshot.docs.isEmpty) {
        // Create the Profile subcollection for the user
        await userDoc.collection('Profile').add({
          'username':
              user.displayName ?? user.email?.split('@')[0] ?? "Unknown User",
          'bio': 'Empty bio', 
          'location':'empty location',// Initial empty bio
          'profileImageUrl':'empty profileImage'// Initial empty bio
        });
      }
    }

    // Once signed in, return the UserCredential
    return userCredential;
  }


  //sing up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password,String userFullname) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create the Profile subcollection for the user
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.uid)
          .collection('Profile')
          .add({
        'username': userFullname, // Store the username here
        'profileImageUrl':'empty profileImage' // Initial empty bio
      });



      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  //sign out

  Future<void> singOut() async {
    await GoogleSignIn().signOut();
    return await _firebaseAuth.signOut();
  }

  Future<void> reauthenticateAndDelete(String email, String password) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      // Reauthenticate the user
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);

      // After successful reauthentication, delete the account
      await deleteUserAccount();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      // Get the current user
      User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception("No user is currently signed in.");
      }

      // Delete user's data from Firestore
      final userDoc =
          FirebaseFirestore.instance.collection("Users").doc(user.uid);

      // Delete the Profile subcollection
      final profileSubcollection = await userDoc.collection('Profile').get();
      for (var doc in profileSubcollection.docs) {
        await doc.reference.delete();
      }

      // Delete the main user document
      await userDoc.delete();

      // Delete the user's authentication account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // If recent login is required
        throw Exception(
          "The user must reauthenticate before this operation can be performed.",
        );
      } else {
        throw Exception(e.code);
      }
    }
  }
}
