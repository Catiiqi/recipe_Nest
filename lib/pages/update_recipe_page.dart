import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/util/mybutton.dart';

import '../util/provider/recipe_provider.dart';

class UpdateRecipePage extends StatefulWidget {
  final String recipeId;
  final String recipeIngredientsText;
  final String recipeStepText;
  const UpdateRecipePage(
      {super.key,
      required this.recipeId,
      required this.recipeIngredientsText,
      required this.recipeStepText});

  @override
  State<UpdateRecipePage> createState() => _UpdateRecipePageState();
}

class _UpdateRecipePageState extends State<UpdateRecipePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recipeIngrident.text = widget.recipeIngredientsText;
    _recipeSteps.text = widget.recipeStepText;
  }

  final _recipeName = TextEditingController();

  final _recipeIngrident = TextEditingController();

  final _recipeSteps = TextEditingController();
  FoodCatogory? selectedCategory = FoodCatogory.vegetarian;

  List myRcipe = [
    ['Nasi Lamak', 'Rice , egg and oil', 'first one clean the rice']
  ];
  void clearfield() {
    _recipeName.clear();
    _recipeSteps.clear();
    _recipeIngrident.clear();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: _recipeIngrident,
                    decoration: InputDecoration(
                      labelText: 'Ingredients',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 8,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _recipeSteps,
                    decoration: InputDecoration(
                      labelText: 'Steps to Make',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 8,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Center(
                child: Mybutton(
                    onPressed: () async {
                      await recipeProvider.updateCurrentRecipe(
                          context,
                          widget.recipeId,
                          _recipeIngrident.text,
                          _recipeSteps.text);
                          await recipeProvider.fetchRecipes();
                          
                    },
                    color: Theme.of(context).colorScheme.primary,
                    child: recipeProvider.isSaving
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Mytext(
                            text: 'Update',
                            color: Colors.white,
                            fontSize: 20,
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
