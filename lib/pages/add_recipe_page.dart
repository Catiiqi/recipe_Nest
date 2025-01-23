import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipenest/util/my_radio_button.dart';
import 'package:recipenest/util/mybutton.dart';

import '../util/provider/recipe_provider.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
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
          title: Text('Add Recipe'),leading: IconButton(onPressed: (){
            Navigator.of(context).pop(true);
            clearfield();
            recipeProvider.clearImge();
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                recipeProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Stack(children: [
                        Center(
                          child: recipeProvider.profileImage == null
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: Text(
                                      '200x200',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    recipeProvider.profileImage!,
                                    height: 200,
                                    width: 250,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 80,
                          bottom: -7,
                          child: IconButton(
                              onPressed: () async {
                                await recipeProvider
                                    .selectAndUploadImage(context);
                              },
                              icon: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.photo_camera_back_outlined,
                                  size: 44,
                                  color: Colors.white,
                                ),
                              )),
                        )
                      ]),
                SizedBox(height: 20),
                TextField(
                  controller: _recipeName,
                  decoration: InputDecoration(
                    labelText: 'Recipe Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _recipeIngrident,
                  decoration: InputDecoration(
                    labelText: 'Ingredients',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _recipeSteps,
                  decoration: InputDecoration(
                    labelText: 'Steps to Make',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                MyRadioButton(
                  initialCharacter: selectedCategory,
                  onCategorySelected: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                SafeArea(
                  child: Center(
                    child: Mybutton(
                        onPressed: recipeProvider.isSaving
                            ? null
                            : () async {
                                await Provider.of<RecipeProvider>(context,
                                        listen: false)
                                    .createNewRecipe(
                                        context,
                                        _recipeName.text,
                                        _recipeIngrident.text,
                                        _recipeSteps.text,
                                        selectedCategory!);

                                _recipeName.clear();
                                _recipeSteps.clear();
                                _recipeIngrident.clear();

                                recipeProvider.clearImge();
                                Navigator.of(context).pop(true);
                              },
                        color: Theme.of(context).colorScheme.primary,
                        child: recipeProvider.isSaving
                            ? Center(child: CircularProgressIndicator(color: Colors.white,))
                            : Mytext(
                                text: 'Save',
                                color: Colors.white,
                                fontSize: 20,
                              )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
