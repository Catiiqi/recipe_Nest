import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../util/provider/favorateProvider.dart'; // Import your FavoriteProvider

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the favorite recipes as soon as the page is loaded
    Future.delayed(Duration.zero, () {
      Provider.of<FavoriteProvider>(context, listen: false)
          .showAllfavoratedRecipe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Favorite Recipes'),
        ),
        body: favoriteProvider.favoritedRecipesDetails.isEmpty
            ? Center(
                child: Text(
                'No favorites Yet',
                style: TextStyle(color: Colors.black),
              ))
            : favoriteProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: favoriteProvider.favoritedRecipesDetails.length,
                    itemBuilder: (context, index) {
                      final recipe =
                          favoriteProvider.favoritedRecipesDetails[index];

                      return ListTile(
                        contentPadding: EdgeInsets.all(20),
                        leading: recipe['profileImage'] != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                recipe['profileImage'],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 200,
                              ))
                            : Icon(Icons.image),
                        title: Text(recipe['recipeName'] ?? 'Unknown Recipe'),
                        onTap: () {},
                      );
                    },
                  ));
  }
}
