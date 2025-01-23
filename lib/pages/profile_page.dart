import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/db/firestore_services.dart';
import 'package:recipenest/pages/favoratesPage.dart';
import 'package:recipenest/util/mybutton.dart';
import '../util/provider/ProfileImageProvider.dart';
import '/Authentication/auth_service.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser == null ||
            FirebaseAuth.instance.currentUser!.email == null
        ? 'Guest'
        : FirebaseAuth.instance.currentUser!.email!;

    final username = userEmail.toString().split('@')[0];
    FirebaseFirestore.instance.collection("Users");
    final profileImageProvider = Provider.of<ProfileImageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices().getProfileFromFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                final userData =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await profileImageProvider
                                .selectAndUploadImage(context);
                          },
                          icon: userData['profileImageUrl'] ==
                                  'empty profileImage'
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                  padding: EdgeInsets.all(50),
                                  child: Icon(
                                    Icons.photo_camera_back_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ))
                              : ClipOval(
                                  child: Image.network(
                                  userData['profileImageUrl'],
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, top: 20.0),
                                      child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null),
                                    );
                                  },
                                )),
                        ),
                        Column(
                          spacing: 16,
                          children: [
                            Text(
                              FirebaseAuth.instance.currentUser == null ||
                                      FirebaseAuth
                                              .instance.currentUser!.email ==
                                          null
                                  ? 'Guest'
                                  : username,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                            SizedBox(
                              height: 170,
                            ),
                            Mybutton(
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FavoritePage()));
                                },
                                child: Mytext(
                                    text: 'Favorite Recipe',
                                    color: Colors.black)),
                            Mybutton(
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  AuthService().singOut();
                                  Navigator.pushReplacementNamed(
                                      context, '/Auth');
                                },
                                child: Mytext(
                                    text: 'Log Out', color: Colors.black))
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text("Document does not exist or is empty."),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile tab index
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.pushNamed(context, '/addRecipe');
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Recipe',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
