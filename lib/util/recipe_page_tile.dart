import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/pages/update_recipe_page.dart';
import 'package:recipenest/util/mybutton.dart';
import 'provider/favorateProvider.dart';

class RecipePageTile extends StatefulWidget {
  final String recipeName;
  final String recipeIngrident;
  final String recipeSteps;
  final String recipeImage;
  final String recipeId;

  const RecipePageTile({
    super.key,
    required this.recipeName,
    required this.recipeIngrident,
    required this.recipeSteps,
    required this.recipeImage,
    required this.recipeId,
  });

  @override
  State<RecipePageTile> createState() => _RecipePageTileState();
}

class _RecipePageTileState extends State<RecipePageTile> {
  @override
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    TextEditingController recipeIngredientsControler = TextEditingController();
    // ignore: unused_local_variable
    TextEditingController recipeStpesController = TextEditingController();

    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    // ignore: unused_element
    void initState() {
      // TODO: implement initState
      super.initState();
      favoriteProvider.fetchFavorites();
    }

    final isFavorite = favoriteProvider.favorites.any(
      (favorite) => favorite['FavoriteRecipeId'] == widget.recipeId,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Mytext(
                  text: widget.recipeName.toUpperCase(),
                  color: Colors.black,
                  fontSize: 20,
                ),
                widget.recipeImage == 'no image'
                    ? Placeholder(
                        fallbackHeight: 120,
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.recipeImage,
                                height: 150,
                                width: 350,
                                fit: BoxFit.fill,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      favoriteProvider
                                          .toggleFavorite(widget.recipeId);
                                    },
                                    child: Image.asset(
                                      isFavorite
                                          ? 'assets/icons/heart_inline.png'
                                          : 'assets/icons/heart.png',
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateRecipePage(
                                                        recipeId:
                                                            widget.recipeId,
                                                        recipeIngredientsText:
                                                            widget
                                                                .recipeIngrident,
                                                        recipeStepText: widget
                                                            .recipeSteps)));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 35,
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'List Of ingredients',
                          style: TextStyle(
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ...widget.recipeIngrident.split('\n').map(
                              (ingredient) => Text(
                                '* $ingredient',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.grey, thickness: 2),
                        const SizedBox(height: 20),
                        Text(
                          'Steps To Produce',
                          style: TextStyle(
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ...widget.recipeSteps.split('\n').map(
                              (step) => Text(
                                '* $step',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
